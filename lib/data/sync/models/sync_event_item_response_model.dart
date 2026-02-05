class SyncEventItemResponseModel {
  const SyncEventItemResponseModel({
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

  factory SyncEventItemResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncEventItemResponseModel(
      id: json['id'] as int,
      entity: json['entity'] as String,
      entityId: json['entity_id'] as int,
      op: json['op'] as String,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
