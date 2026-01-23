import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/sync/datasources/sync_local_datasource.dart';
import 'package:taskify/data/sync/datasources/sync_remote_datasource.dart';
import 'package:taskify/data/sync/models/sync_changes_model.dart';
import 'package:taskify/data/sync/models/sync_event_model.dart';
import 'package:taskify/data/sync/models/sync_id_map_model.dart';
import 'package:taskify/data/sync/models/sync_op_data_model.dart';
import 'package:taskify/data/sync/models/sync_op_input_model.dart';
import 'package:taskify/data/sync/models/sync_push_response_model.dart';
import 'package:taskify/data/sync/models/sync_queue_entry_model.dart';
import 'package:taskify/data/sync/models/sync_state_model.dart';
import 'package:taskify/domain/sync/models/sync_change.dart';
import 'package:taskify/domain/sync/models/sync_changes.dart';
import 'package:taskify/domain/sync/models/sync_id_map.dart';
import 'package:taskify/domain/sync/models/sync_op.dart';
import 'package:taskify/domain/sync/models/sync_op_data.dart';
import 'package:taskify/domain/sync/models/sync_op_error.dart';
import 'package:taskify/domain/sync/models/sync_push_result.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry.dart';
import 'package:taskify/domain/sync/models/sync_state.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl(this._local, this._remote);

  final SyncLocalDataSource _local;
  final SyncRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<SyncQueueEntry>>> getQueuedOps({
    int limit = 200,
  }) async {
    final result = await _local.getQueuedOps(limit: limit);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (ops) => Right(ops.map(_mapQueueModelToEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntry entry) {
    return _local.enqueueOp(_mapQueueEntityToModel(entry));
  }

  @override
  Future<Either<Failure, void>> removeQueuedOps(List<String> opIds) {
    return _local.removeOpsByOpIds(opIds);
  }

  @override
  Future<Either<Failure, SyncPushResult>> pushChanges({
    required String deviceId,
    required List<SyncOp> ops,
  }) async {
    final result = await _remote.pushChanges(
      deviceId: deviceId,
      ops: ops.map(_mapOpEntityToModel).toList(),
    );
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (response) => Right(_mapPushResponseToEntity(response)),
    );
  }

  @override
  Future<Either<Failure, SyncChanges>> pullChanges({
    required int cursor,
    int limit = 200,
    bool compact = true,
  }) async {
    final result = await _remote.getChanges(
      cursor: cursor,
      limit: limit,
      compact: compact,
    );
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (response) => Right(_mapChangesToEntity(response)),
    );
  }

  @override
  Future<Either<Failure, void>> applyIdMap(
    Map<String, List<SyncIdMap>> idMap,
  ) {
    final mapped = idMap.map(
      (key, value) =>
          MapEntry(key, value.map(_mapIdMapEntityToModel).toList()),
    );
    return _local.applyIdMap(mapped);
  }

  @override
  Future<Either<Failure, void>> applyChanges(List<SyncChange> changes) {
    final mapped = changes.map(_mapChangeEntityToModel).toList();
    return _local.applyChanges(mapped);
  }

  @override
  Future<Either<Failure, SyncState>> getState() async {
    final result = await _local.getState();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (state) => Right(_mapStateModelToEntity(state)),
    );
  }

  @override
  Future<Either<Failure, void>> saveState(SyncState state) {
    return _local.saveState(_mapStateEntityToModel(state));
  }

  SyncQueueEntry _mapQueueModelToEntity(SyncQueueEntryModel model) {
    return SyncQueueEntry(
      opId: model.opId,
      entity: model.entity,
      op: model.op,
      id: model.networkId,
      clientId: model.clientId,
      data: model.data == null ? null : _mapOpDataModelToEntity(model.data!),
    );
  }

  SyncQueueEntryModel _mapQueueEntityToModel(SyncQueueEntry entity) {
    return SyncQueueEntryModel(
      opId: entity.opId,
      entity: entity.entity,
      op: entity.op,
      clientId: entity.clientId,
      networkId: entity.id,
      data: entity.data == null ? null : _mapOpDataEntityToModel(entity.data!),
    );
  }

  SyncOpInputModel _mapOpEntityToModel(SyncOp entity) {
    return SyncOpInputModel(
      opId: entity.opId,
      entity: entity.entity,
      op: entity.op,
      id: entity.id,
      clientId: entity.clientId,
      data: entity.data == null ? null : _mapOpDataEntityToModel(entity.data!),
    );
  }

  SyncPushResult _mapPushResponseToEntity(SyncPushResponseModel model) {
    return SyncPushResult(
      ack: model.ack,
      idMap: model.idMap.map(
        (key, value) => MapEntry(
          key,
          value.map(_mapIdMapModelToEntity).toList(),
        ),
      ),
      errors: model.errors
          .map(
            (error) => SyncOpError(
              opId: error.opId,
              code: error.code,
              message: error.message,
            ),
          )
          .toList(),
    );
  }

  SyncChanges _mapChangesToEntity(SyncChangesModel model) {
    return SyncChanges(
      nextCursor: model.nextCursor,
      changes: model.changes.map(_mapChangeModelToEntity).toList(),
    );
  }

  SyncChange _mapChangeModelToEntity(SyncEventModel model) {
    return SyncChange(
      id: model.id,
      entity: model.entity,
      entityId: model.entityId,
      op: model.op,
      occurredAt: model.occurredAt,
      data: model.data,
    );
  }

  SyncEventModel _mapChangeEntityToModel(SyncChange entity) {
    return SyncEventModel(
      id: entity.id,
      entity: entity.entity,
      entityId: entity.entityId,
      op: entity.op,
      occurredAt: entity.occurredAt,
      data: entity.data,
    );
  }

  SyncOpData _mapOpDataModelToEntity(SyncOpDataModel model) {
    return SyncOpData(
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      text: model.text,
      taskId: model.taskId,
      taskClientId: model.taskClientId,
      name: model.name,
      color: model.color,
      isUserTag: model.isUserTag,
    );
  }

  SyncOpDataModel _mapOpDataEntityToModel(SyncOpData entity) {
    return SyncOpDataModel(
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      text: entity.text,
      taskId: entity.taskId,
      taskClientId: entity.taskClientId,
      name: entity.name,
      color: entity.color,
      isUserTag: entity.isUserTag,
    );
  }

  SyncIdMap _mapIdMapModelToEntity(SyncIdMapModel model) {
    return SyncIdMap(clientId: model.clientId, id: model.id);
  }

  SyncIdMapModel _mapIdMapEntityToModel(SyncIdMap entity) {
    return SyncIdMapModel(clientId: entity.clientId, id: entity.id);
  }

  SyncState _mapStateModelToEntity(SyncStateModel model) {
    return SyncState(
      deviceId: model.deviceId,
      lastCursor: model.lastCursor,
      lastSyncedAt: model.lastSyncedAt,
    );
  }

  SyncStateModel _mapStateEntityToModel(SyncState entity) {
    return SyncStateModel(
      deviceId: entity.deviceId,
      lastCursor: entity.lastCursor,
      lastSyncedAt: entity.lastSyncedAt,
    );
  }
}
