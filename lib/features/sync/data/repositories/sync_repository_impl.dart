import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/sync/data/datasources/sync_local_datasource.dart';
import 'package:taskify/features/sync/data/datasources/sync_remote_datasource.dart';
import 'package:taskify/features/sync/data/models/sync_changes_response_model.dart';
import 'package:taskify/features/sync/data/models/sync_event_item_response_model.dart';
import 'package:taskify/features/sync/data/models/sync_id_map_item_response_model.dart';
import 'package:taskify/features/sync/data/models/sync_op_data_request_model.dart';
import 'package:taskify/features/sync/data/models/sync_op_input_request_model.dart';
import 'package:taskify/features/sync/data/models/sync_push_response_model.dart';
import 'package:taskify/features/sync/data/models/sync_queue_entry_model.dart';
import 'package:taskify/features/sync/data/models/sync_state_model.dart';
import 'package:taskify/features/sync/domain/models/sync_change_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_changes_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_id_map_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_op_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_op_data_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_op_error_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_push_result_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_queue_entry_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_state_entity.dart';
import 'package:taskify/features/sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl(this._local, this._remote);

  final SyncLocalDataSource _local;
  final SyncRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<SyncQueueEntryEntity>>> getQueuedOps({
    int limit = 200,
  }) async {
    final result = await _local.getQueuedOps(limit: limit);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (ops) => Right(ops.map(_mapQueueModelToEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntryEntity entry) {
    return _local.enqueueOp(_mapQueueEntityToModel(entry));
  }

  @override
  Future<Either<Failure, void>> removeQueuedOps(List<String> opIds) {
    return _local.removeOpsByOpIds(opIds);
  }

  @override
  Future<Either<Failure, SyncPushResultEntity>> pushChanges({
    required String deviceId,
    required List<SyncOpEntity> ops,
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
  Future<Either<Failure, SyncChangesEntity>> pullChanges({
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
    Map<String, List<SyncIdMapEntity>> idMap,
  ) {
    final mapped = idMap.map(
      (key, value) => MapEntry(key, value.map(_mapIdMapEntityToModel).toList()),
    );
    return _local.applyIdMap(mapped);
  }

  @override
  Future<Either<Failure, void>> applyChanges(List<SyncChangeEntity> changes) {
    final mapped = changes.map(_mapChangeEntityToModel).toList();
    return _local.applyChanges(mapped);
  }

  @override
  Future<Either<Failure, SyncStateEntity>> getState() async {
    final result = await _local.getState();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (state) => Right(_mapStateModelToEntity(state)),
    );
  }

  @override
  Future<Either<Failure, void>> saveState(SyncStateEntity state) {
    return _local.saveState(_mapStateEntityToModel(state));
  }

  SyncQueueEntryEntity _mapQueueModelToEntity(SyncQueueEntryModel model) {
    return SyncQueueEntryEntity(
      opId: model.opId,
      entity: model.entity,
      op: model.op,
      id: model.networkId,
      clientId: model.clientId,
      data: model.data == null ? null : _mapOpDataModelToEntity(model.data!),
    );
  }

  SyncQueueEntryModel _mapQueueEntityToModel(SyncQueueEntryEntity entity) {
    return SyncQueueEntryModel(
      opId: entity.opId,
      entity: entity.entity,
      op: entity.op,
      clientId: entity.clientId,
      networkId: entity.id,
      data: entity.data == null ? null : _mapOpDataEntityToModel(entity.data!),
    );
  }

  SyncOpInputRequestModel _mapOpEntityToModel(SyncOpEntity entity) {
    return SyncOpInputRequestModel(
      opId: entity.opId,
      entity: entity.entity,
      op: entity.op,
      id: entity.id,
      clientId: entity.clientId,
      data: entity.data == null ? null : _mapOpDataEntityToModel(entity.data!),
    );
  }

  SyncPushResultEntity _mapPushResponseToEntity(SyncPushResponseModel model) {
    return SyncPushResultEntity(
      ack: model.ack,
      idMap: model.idMap.map(
        (key, value) =>
            MapEntry(key, value.map(_mapIdMapModelToEntity).toList()),
      ),
      errors: model.errors
          .map(
            (error) => SyncOpErrorEntity(
              opId: error.opId,
              code: error.code,
              message: error.message,
            ),
          )
          .toList(),
    );
  }

  SyncChangesEntity _mapChangesToEntity(SyncChangesResponseModel model) {
    return SyncChangesEntity(
      nextCursor: model.nextCursor,
      changes: model.changes.map(_mapChangeModelToEntity).toList(),
    );
  }

  SyncChangeEntity _mapChangeModelToEntity(SyncEventItemResponseModel model) {
    return SyncChangeEntity(
      id: model.id,
      entity: model.entity,
      entityId: model.entityId,
      op: model.op,
      occurredAt: model.occurredAt,
      data: model.data,
    );
  }

  SyncEventItemResponseModel _mapChangeEntityToModel(SyncChangeEntity entity) {
    return SyncEventItemResponseModel(
      id: entity.id,
      entity: entity.entity,
      entityId: entity.entityId,
      op: entity.op,
      occurredAt: entity.occurredAt,
      data: entity.data,
    );
  }

  SyncOpDataEntity _mapOpDataModelToEntity(SyncOpDataRequestModel model) {
    return SyncOpDataEntity(
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

  SyncOpDataRequestModel _mapOpDataEntityToModel(SyncOpDataEntity entity) {
    return SyncOpDataRequestModel(
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

  SyncIdMapEntity _mapIdMapModelToEntity(SyncIdMapItemResponseModel model) {
    return SyncIdMapEntity(clientId: model.clientId, id: model.id);
  }

  SyncIdMapItemResponseModel _mapIdMapEntityToModel(SyncIdMapEntity entity) {
    return SyncIdMapItemResponseModel(clientId: entity.clientId, id: entity.id);
  }

  SyncStateEntity _mapStateModelToEntity(SyncStateModel model) {
    return SyncStateEntity(
      deviceId: model.deviceId,
      lastCursor: model.lastCursor,
      lastSyncedAt: model.lastSyncedAt,
    );
  }

  SyncStateModel _mapStateEntityToModel(SyncStateEntity entity) {
    return SyncStateModel(
      deviceId: entity.deviceId,
      lastCursor: entity.lastCursor,
      lastSyncedAt: entity.lastSyncedAt,
    );
  }
}
