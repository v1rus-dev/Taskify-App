import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/sync/models/sync_change.dart';
import 'package:taskify/domain/sync/models/sync_changes.dart';
import 'package:taskify/domain/sync/models/sync_id_map.dart';
import 'package:taskify/domain/sync/models/sync_op.dart';
import 'package:taskify/domain/sync/models/sync_push_result.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry.dart';
import 'package:taskify/domain/sync/models/sync_state.dart';

abstract class SyncRepository {
  Future<Either<Failure, List<SyncQueueEntry>>> getQueuedOps({int limit});
  Future<Either<Failure, void>> enqueueOp(SyncQueueEntry entry);
  Future<Either<Failure, void>> removeQueuedOps(List<String> opIds);

  Future<Either<Failure, SyncPushResult>> pushChanges({
    required String deviceId,
    required List<SyncOp> ops,
  });

  Future<Either<Failure, SyncChanges>> pullChanges({
    required int cursor,
    int limit,
    bool compact,
  });

  Future<Either<Failure, void>> applyIdMap(
    Map<String, List<SyncIdMap>> idMap,
  );

  Future<Either<Failure, void>> applyChanges(List<SyncChange> changes);

  Future<Either<Failure, SyncState>> getState();
  Future<Either<Failure, void>> saveState(SyncState state);
}
