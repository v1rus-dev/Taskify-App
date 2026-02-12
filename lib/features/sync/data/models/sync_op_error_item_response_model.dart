class SyncOpErrorItemResponseModel {
  const SyncOpErrorItemResponseModel({
    required this.opId,
    required this.code,
    required this.message,
  });

  final String opId;
  final String code;
  final String message;

  factory SyncOpErrorItemResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncOpErrorItemResponseModel(
      opId: json['op_id'] as String,
      code: json['code'] as String,
      message: json['message'] as String,
    );
  }
}
