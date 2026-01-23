import 'package:taskify/data/sync/models/sync_op_input_model.dart';

class SyncPushRequestModel {
  const SyncPushRequestModel({
    required this.ops,
    this.deviceId,
  });

  final String? deviceId;
  final List<SyncOpInputModel> ops;

  factory SyncPushRequestModel.fromJson(Map<String, dynamic> json) {
    return SyncPushRequestModel(
      deviceId: json['device_id'] as String?,
      ops: (json['ops'] as List<dynamic>)
          .map((op) => SyncOpInputModel.fromJson(op as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'ops': ops.map((op) => op.toJson()).toList(),
    };
  }
}
