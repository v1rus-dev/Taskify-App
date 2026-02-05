class SyncIdMapItemResponseModel {
  const SyncIdMapItemResponseModel({
    required this.clientId,
    required this.id,
  });

  final String clientId;
  final int id;

  factory SyncIdMapItemResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncIdMapItemResponseModel(
      clientId: json['client_id'] as String,
      id: json['id'] as int,
    );
  }
}
