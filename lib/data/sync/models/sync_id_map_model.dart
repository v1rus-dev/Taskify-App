class SyncIdMapModel {
  const SyncIdMapModel({
    required this.clientId,
    required this.id,
  });

  final String clientId;
  final int id;

  factory SyncIdMapModel.fromJson(Map<String, dynamic> json) {
    return SyncIdMapModel(
      clientId: json['client_id'] as String,
      id: json['id'] as int,
    );
  }
}
