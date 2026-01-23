import 'package:taskify/domain/sync/models/sync_op_data.dart';

class SyncOp {
  const SyncOp({
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
  final SyncOpData? data;
}
