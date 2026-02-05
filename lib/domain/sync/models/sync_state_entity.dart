class SyncStateEntity {
  const SyncStateEntity({
    required this.deviceId,
    required this.lastCursor,
    this.lastSyncedAt,
  });

  final String? deviceId;
  final int lastCursor;
  final DateTime? lastSyncedAt;

  SyncStateEntity copyWith({
    String? deviceId,
    int? lastCursor,
    DateTime? lastSyncedAt,
  }) {
    return SyncStateEntity(
      deviceId: deviceId ?? this.deviceId,
      lastCursor: lastCursor ?? this.lastCursor,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
