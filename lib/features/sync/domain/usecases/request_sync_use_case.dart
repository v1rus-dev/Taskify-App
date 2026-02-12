import 'package:taskify/features/sync/domain/services/sync_coordinator.dart';

class RequestSyncUseCase {
  RequestSyncUseCase(this._coordinator);

  final SyncCoordinator _coordinator;

  void call({
    required String reason,
    Duration debounce = const Duration(seconds: 3),
  }) {
    _coordinator.scheduleSync(reason: reason, debounce: debounce);
  }
}
