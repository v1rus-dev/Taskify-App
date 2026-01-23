class SyncState {
  const SyncState({
    required this.deviceId,
    required this.lastCursor,
    this.lastSyncedAt,
  });

  final String? deviceId;
  final int lastCursor;
  final DateTime? lastSyncedAt;

  SyncState copyWith({
    String? deviceId,
    int? lastCursor,
    DateTime? lastSyncedAt,
  }) {
    return SyncState(
      deviceId: deviceId ?? this.deviceId,
      lastCursor: lastCursor ?? this.lastCursor,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
