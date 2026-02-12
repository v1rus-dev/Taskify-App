import 'package:taskify/features/sync/data/models/sync_op_input_request_model.dart';

class SyncPushRequestModel {
  const SyncPushRequestModel({required this.ops, this.deviceId});

  final String? deviceId;
  final List<SyncOpInputRequestModel> ops;

  factory SyncPushRequestModel.fromJson(Map<String, dynamic> json) {
    return SyncPushRequestModel(
      deviceId: json['device_id'] as String?,
      ops: (json['ops'] as List<dynamic>)
          .map(
            (op) =>
                SyncOpInputRequestModel.fromJson(op as Map<String, dynamic>),
          )
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
