class SyncStateModel {
  const SyncStateModel({
    required this.deviceId,
    required this.lastCursor,
    this.lastSyncedAt,
  });

  final String? deviceId;
  final int lastCursor;
  final DateTime? lastSyncedAt;
}
