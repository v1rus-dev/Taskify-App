import 'dart:convert';

import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/tables/sync_state_table.dart';
import 'package:taskify/data/sync/models/sync_event_item_response_model.dart';
import 'package:taskify/data/sync/models/sync_id_map_item_response_model.dart';
import 'package:taskify/data/sync/models/sync_op_data_request_model.dart';
import 'package:taskify/data/sync/models/sync_queue_entry_model.dart';
import 'package:taskify/data/sync/models/sync_state_model.dart';

abstract class SyncLocalDataSource {
  Future<Either<Failure, List<SyncQueueEntryModel>>> getQueuedOps({
    int limit = 200,
  });
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntryModel entry);
  Future<Either<Failure, void>> removeOpsByOpIds(List<String> opIds);
  Future<Either<Failure, SyncStateModel>> getState();
  Future<Either<Failure, void>> saveState(SyncStateModel state);
  Future<Either<Failure, void>> applyIdMap(
    Map<String, List<SyncIdMapItemResponseModel>> idMap,
  );
  Future<Either<Failure, void>> applyChanges(
    List<SyncEventItemResponseModel> changes,
  );
}

class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  SyncLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Either<Failure, List<SyncQueueEntryModel>>> getQueuedOps({
    int limit = 200,
  }) async {
    try {
      TalkerService.instance.info('syncTag getQueuedOps start: $limit');
      final rows = await (_database.select(_database.syncQueueTable)
            ..orderBy([
              (row) => OrderingTerm(
                expression: row.createdAt,
                mode: OrderingMode.asc,
              )
            ])
            ..limit(limit))
          .get();
      final ops = rows.map((row) {
        final payload = row.payload == null
            ? null
            : jsonDecode(row.payload!) as Map<String, dynamic>;
        return SyncQueueEntryModel(
          id: row.id,
          opId: row.opId,
          entity: row.entity,
          op: row.op,
          clientId: row.clientId,
          networkId: row.networkId,
          data: payload == null ? null : SyncOpDataRequestModel.fromJson(payload),
        );
      }).toList();
      TalkerService.instance.info('syncTag getQueuedOps result: ${ops.length}');
      return Right(ops);
    } catch (e) {
      TalkerService.instance.error('syncTag getQueuedOps error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntryModel entry) async {
    try {
      TalkerService.instance.info(
        'syncTag enqueueOp start: ${entry.entity} ${entry.op}',
      );
      await _database.into(_database.syncQueueTable).insert(
            SyncQueueTableCompanion(
              opId: Value(entry.opId),
              entity: Value(entry.entity),
              op: Value(entry.op),
              clientId: Value(entry.clientId),
              networkId: Value(entry.networkId),
              payload: Value(
                entry.data == null ? null : jsonEncode(entry.data!.toJson()),
              ),
            ),
          );
      TalkerService.instance.info('syncTag enqueueOp done: ${entry.opId}');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag enqueueOp error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeOpsByOpIds(List<String> opIds) async {
    try {
      if (opIds.isEmpty) {
        return const Right(null);
      }
      TalkerService.instance.info(
        'syncTag removeOpsByOpIds start: ${opIds.length}',
      );
      await (_database.delete(_database.syncQueueTable)
            ..where((row) => row.opId.isIn(opIds)))
          .go();
      TalkerService.instance.info('syncTag removeOpsByOpIds done');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag removeOpsByOpIds error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncStateModel>> getState() async {
    try {
      TalkerService.instance.info('syncTag getState start');
      final row = await (_database.select(_database.syncStateTable)
            ..where((state) => state.id.equals(SyncStateTable.defaultId)))
          .getSingleOrNull();
      if (row == null) {
        final initial = const SyncStateModel(
          deviceId: null,
          lastCursor: 0,
          lastSyncedAt: null,
        );
        await saveState(initial);
        TalkerService.instance.info('syncTag getState created default');
        return Right(initial);
      }
      final state = SyncStateModel(
        deviceId: row.deviceId,
        lastCursor: row.lastCursor,
        lastSyncedAt: row.lastSyncedAt,
      );
      TalkerService.instance.info('syncTag getState result: ${state.lastCursor}');
      return Right(state);
    } catch (e) {
      TalkerService.instance.error('syncTag getState error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveState(SyncStateModel state) async {
    try {
      TalkerService.instance.info('syncTag saveState start');
      await _database.into(_database.syncStateTable).insertOnConflictUpdate(
            SyncStateTableCompanion(
              id: const Value(SyncStateTable.defaultId),
              deviceId: Value(state.deviceId),
              lastCursor: Value(state.lastCursor),
              lastSyncedAt: Value(state.lastSyncedAt),
            ),
          );
      TalkerService.instance.info('syncTag saveState done');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag saveState error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> applyIdMap(
    Map<String, List<SyncIdMapItemResponseModel>> idMap,
  ) async {
    try {
      TalkerService.instance.info('syncTag applyIdMap start');
      final taskMap = idMap['task'] ?? [];
      final subTaskMap = idMap['subtask'] ?? [];
      await _database.transaction(() async {
        for (final entry in taskMap) {
          await (_database.update(_database.tasksTable)
                ..where((task) => task.clientId.equals(entry.clientId)))
              .write(
            TasksTableCompanion(networkId: Value(entry.id)),
          );
        }
        for (final entry in subTaskMap) {
          await (_database.update(_database.subtasksTable)
                ..where((subtask) =>
                    subtask.clientId.equals(entry.clientId)))
              .write(
            SubtasksTableCompanion(networkId: Value(entry.id)),
          );
        }
      });
      TalkerService.instance.info('syncTag applyIdMap done');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag applyIdMap error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> applyChanges(
    List<SyncEventItemResponseModel> changes,
  ) async {
    try {
      TalkerService.instance.info(
        'syncTag applyChanges start: ${changes.length}',
      );
      await _database.transaction(() async {
        for (final change in changes) {
          switch (change.entity) {
            case 'task':
              await _applyTaskChange(change);
              break;
            case 'subtask':
              await _applySubTaskChange(change);
              break;
            default:
              TalkerService.instance.warning(
                'syncTag applyChanges skip entity: ${change.entity}',
              );
          }
        }
      });
      TalkerService.instance.info('syncTag applyChanges done');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag applyChanges error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  Future<void> _applyTaskChange(SyncEventItemResponseModel change) async {
    final data = change.data ?? {};
    final clientId = data['client_id'] as String?;
    final deletedAtRaw = data['deleted_at'] as String?;
    final deletedAt =
        deletedAtRaw == null ? null : DateTime.tryParse(deletedAtRaw);
    final updatedAtRaw = data['updated_at'] as String?;
    final updatedAt =
        updatedAtRaw == null ? null : DateTime.tryParse(updatedAtRaw);
    final createdAtRaw = data['created_at'] as String?;
    final createdAt =
        createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw);

    var existing = await (_database.select(_database.tasksTable)
          ..where((task) => task.networkId.equals(change.entityId)))
        .getSingleOrNull();
    if (existing == null && clientId != null) {
      existing = await (_database.select(_database.tasksTable)
            ..where((task) => task.clientId.equals(clientId)))
          .getSingleOrNull();
    }
    final title = data['title'] as String? ?? existing?.title ?? '';
    final description = data['description'] as String? ?? existing?.description;
    final isCompleted =
        data['is_completed'] as bool? ?? existing?.isCompleted ?? false;
    final date = existing?.date ?? change.occurredAt;

    if (change.op == 'delete') {
      if (existing == null) {
        return;
      }
      await (_database.update(_database.tasksTable)
            ..where((task) => task.id.equals(existing!.id)))
          .write(
        TasksTableCompanion(
          deletedAt: Value(deletedAt ?? DateTime.now()),
          updatedAt: Value(updatedAt ?? DateTime.now()),
        ),
      );
      return;
    }

    if (existing == null) {
      await _database.into(_database.tasksTable).insert(
            TasksTableCompanion(
              networkId: Value(change.entityId),
              clientId: Value(clientId),
              title: Value(title),
              description: Value(description),
              isCompleted: Value(isCompleted),
              date: Value(date),
              isAllDay: const Value(true),
              createdAt: Value(createdAt ?? DateTime.now()),
              updatedAt: Value(updatedAt ?? DateTime.now()),
              deletedAt: Value(deletedAt),
            ),
          );
      return;
    }

    await (_database.update(_database.tasksTable)
          ..where((task) => task.id.equals(existing!.id)))
        .write(
      TasksTableCompanion(
        clientId: Value(clientId ?? existing.clientId),
        title: Value(title),
        description: Value(description),
        isCompleted: Value(isCompleted),
        updatedAt: Value(updatedAt ?? DateTime.now()),
        deletedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> _applySubTaskChange(SyncEventItemResponseModel change) async {
    final data = change.data ?? {};
    final clientId = data['client_id'] as String?;
    final deletedAtRaw = data['deleted_at'] as String?;
    final deletedAt =
        deletedAtRaw == null ? null : DateTime.tryParse(deletedAtRaw);
    final updatedAtRaw = data['updated_at'] as String?;
    final updatedAt =
        updatedAtRaw == null ? null : DateTime.tryParse(updatedAtRaw);
    final createdAtRaw = data['created_at'] as String?;
    final createdAt =
        createdAtRaw == null ? null : DateTime.tryParse(createdAtRaw);

    final taskId = data['task_id'] as int?;
    final taskClientId = data['task_client_id'] as String?;
    final localTaskId =
        await _resolveLocalTaskId(taskId: taskId, taskClientId: taskClientId);
    if (localTaskId == null) {
      TalkerService.instance.warning(
        'syncTag subtask skipped: task not found',
      );
      return;
    }

    var existing = await (_database.select(_database.subtasksTable)
          ..where((subtask) => subtask.networkId.equals(change.entityId)))
        .getSingleOrNull();
    if (existing == null && clientId != null) {
      existing = await (_database.select(_database.subtasksTable)
            ..where((subtask) => subtask.clientId.equals(clientId)))
          .getSingleOrNull();
    }
    final title = data['text'] as String? ?? existing?.title ?? '';
    final isCompleted =
        data['is_completed'] as bool? ?? existing?.isCompleted ?? false;

    if (change.op == 'delete') {
      if (existing == null) {
        return;
      }
      await (_database.update(_database.subtasksTable)
            ..where((subtask) => subtask.id.equals(existing!.id)))
          .write(
        SubtasksTableCompanion(
          deletedAt: Value(deletedAt ?? DateTime.now()),
          updatedAt: Value(updatedAt ?? DateTime.now()),
        ),
      );
      return;
    }

    if (existing == null) {
      await _database.into(_database.subtasksTable).insert(
            SubtasksTableCompanion(
              networkId: Value(change.entityId),
              clientId: Value(clientId),
              taskId: Value(localTaskId),
              title: Value(title),
              isCompleted: Value(isCompleted),
              createdAt: Value(createdAt ?? DateTime.now()),
              updatedAt: Value(updatedAt ?? DateTime.now()),
              deletedAt: Value(deletedAt),
            ),
          );
      return;
    }

    await (_database.update(_database.subtasksTable)
          ..where((subtask) => subtask.id.equals(existing!.id)))
        .write(
      SubtasksTableCompanion(
        clientId: Value(clientId ?? existing.clientId),
        taskId: Value(localTaskId),
        title: Value(title),
        isCompleted: Value(isCompleted),
        updatedAt: Value(updatedAt ?? DateTime.now()),
        deletedAt: Value(deletedAt),
      ),
    );
  }

  Future<int?> _resolveLocalTaskId({
    int? taskId,
    String? taskClientId,
  }) async {
    if (taskId != null) {
      final task = await (_database.select(_database.tasksTable)
            ..where((row) => row.networkId.equals(taskId)))
          .getSingleOrNull();
      return task?.id;
    }
    if (taskClientId != null) {
      final task = await (_database.select(_database.tasksTable)
            ..where((row) => row.clientId.equals(taskClientId)))
          .getSingleOrNull();
      return task?.id;
    }
    return null;
  }
}
