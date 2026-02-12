import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/sync/domain/usecases/sync_interactor.dart';

class RunSyncUseCase {
  RunSyncUseCase(this._interactor);

  final SyncInteractor _interactor;

  Future<Either<Failure, void>> call({required String deviceId}) {
    return _interactor.sync(deviceId: deviceId);
  }
}
