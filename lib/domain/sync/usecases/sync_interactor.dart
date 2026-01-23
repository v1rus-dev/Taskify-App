import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/sync/models/sync_op.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry.dart';
import 'package:taskify/domain/sync/models/sync_state.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';

class SyncInteractor {
  SyncInteractor(this._repository);

  final SyncRepository _repository;

  Future<Either<Failure, void>> sync({required String deviceId}) async {
    TalkerService.instance.info('syncTag sync start');
    final stateResult = await _repository.getState();
    Failure? failure;
    SyncState? state;
    stateResult.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => state = right,
    );
    if (failure != null) {
      TalkerService.instance.error('syncTag sync state error', failure);
      return Left(failure!);
    }

    final queueResult = await _repository.getQueuedOps();
    List<SyncQueueEntry> queued = const [];
    queueResult.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => queued = right,
    );
    if (failure != null) {
      TalkerService.instance.error('syncTag sync queue error', failure);
      return Left(failure!);
    }

    if (queued.isNotEmpty) {
      final ops = queued.map(_mapQueueToOp).toList();
      final pushResult =
          await _repository.pushChanges(deviceId: deviceId, ops: ops);
      pushResult.fold(
        ifLeft: (left) => failure = left,
        ifRight: (right) async {
          if (right.ack.isNotEmpty) {
            final removed = await _repository.removeQueuedOps(right.ack);
            removed.fold(
              ifLeft: (left) => failure ??= left,
              ifRight: (_) {},
            );
          }
          if (right.idMap.isNotEmpty) {
            final applied = await _repository.applyIdMap(right.idMap);
            applied.fold(
              ifLeft: (left) => failure ??= left,
              ifRight: (_) {},
            );
          }
          if (right.errors.isNotEmpty) {
            TalkerService.instance.warning(
              'syncTag push errors: ${right.errors.length}',
            );
          }
        },
      );
      if (failure != null) {
        TalkerService.instance.error('syncTag sync push error', failure);
        return Left(failure!);
      }
    }

    final pullResult = await _repository.pullChanges(cursor: state!.lastCursor);
    pullResult.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) async {
        if (right.changes.isNotEmpty) {
          final applied = await _repository.applyChanges(right.changes);
          applied.fold(
            ifLeft: (left) => failure ??= left,
            ifRight: (_) {},
          );
        }
        final updatedState = state!.copyWith(
          deviceId: deviceId,
          lastCursor: right.nextCursor,
          lastSyncedAt: DateTime.now(),
        );
        final saved = await _repository.saveState(updatedState);
        saved.fold(
          ifLeft: (left) => failure ??= left,
          ifRight: (_) {},
        );
      },
    );
    if (failure != null) {
      TalkerService.instance.error('syncTag sync pull error', failure);
      return Left(failure!);
    }

    TalkerService.instance.info('syncTag sync done');
    return const Right(null);
  }

  SyncOp _mapQueueToOp(SyncQueueEntry entry) {
    return SyncOp(
      opId: entry.opId,
      entity: entry.entity,
      op: entry.op,
      id: entry.id,
      clientId: entry.clientId,
      data: entry.data,
    );
  }
}
