import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/sync/domain/models/sync_change_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_changes_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_id_map_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_op_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_push_result_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_queue_entry_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_state_entity.dart';

abstract class SyncRepository {
  Future<Either<Failure, List<SyncQueueEntryEntity>>> getQueuedOps({int limit});
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntryEntity entry);
  Future<Either<Failure, void>> removeQueuedOps(List<String> opIds);

  Future<Either<Failure, SyncPushResultEntity>> pushChanges({
    required String deviceId,
    required List<SyncOpEntity> ops,
  });

  Future<Either<Failure, SyncChangesEntity>> pullChanges({
    required int cursor,
    int limit,
    bool compact,
  });

  Future<Either<Failure, void>> applyIdMap(
    Map<String, List<SyncIdMapEntity>> idMap,
  );

  Future<Either<Failure, void>> applyChanges(List<SyncChangeEntity> changes);

  Future<Either<Failure, SyncStateEntity>> getState();
  Future<Either<Failure, void>> saveState(SyncStateEntity state);
}
