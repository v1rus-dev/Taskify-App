class SyncOpErrorModel {
  const SyncOpErrorModel({
    required this.opId,
    required this.code,
    required this.message,
  });

  final String opId;
  final String code;
  final String message;

  factory SyncOpErrorModel.fromJson(Map<String, dynamic> json) {
    return SyncOpErrorModel(
      opId: json['op_id'] as String,
      code: json['code'] as String,
      message: json['message'] as String,
    );
  }
}
