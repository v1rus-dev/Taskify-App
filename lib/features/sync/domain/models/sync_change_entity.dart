class SyncChangeEntity {
  const SyncChangeEntity({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.occurredAt,
    this.data,
  });

  final int id;
  final String entity;
  final int entityId;
  final String op;
  final DateTime occurredAt;
  final Map<String, dynamic>? data;
}
