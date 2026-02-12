import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/sync/domain/models/sync_state_entity.dart';
import 'package:taskify/features/sync/domain/repositories/sync_repository.dart';

class GetSyncStateUseCase {
  GetSyncStateUseCase(this._repository);

  final SyncRepository _repository;

  Future<Either<Failure, SyncStateEntity>> call() {
    return _repository.getState();
  }
}
