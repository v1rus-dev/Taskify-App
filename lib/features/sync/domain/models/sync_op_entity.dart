import 'package:taskify/features/sync/domain/models/sync_op_data_entity.dart';

class SyncOpEntity {
  const SyncOpEntity({
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
  final SyncOpDataEntity? data;
}
