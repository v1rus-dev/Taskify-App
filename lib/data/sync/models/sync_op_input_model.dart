import 'package:taskify/data/sync/models/sync_op_data_model.dart';

class SyncOpInputModel {
  const SyncOpInputModel({
    required this.opId,
    required this.entity,
    required this.op,
    this.id,
    this.clientId,
    this.data,
  });

  final String opId;
  final String entity;
  final String op;
  final int? id;
  final String? clientId;
  final SyncOpDataModel? data;

  factory SyncOpInputModel.fromJson(Map<String, dynamic> json) {
    return SyncOpInputModel(
      opId: json['op_id'] as String,
      entity: json['entity'] as String,
      op: json['op'] as String,
      id: json['id'] as int?,
      clientId: json['client_id'] as String?,
      data: json['data'] == null
          ? null
          : SyncOpDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'op_id': opId,
      'entity': entity,
      'op': op,
      'id': id,
      'client_id': clientId,
      'data': data?.toJson(),
    };
  }
}
