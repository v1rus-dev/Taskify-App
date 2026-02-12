import 'package:taskify/features/sync/data/models/sync_op_data_request_model.dart';

class SyncQueueEntryModel {
  const SyncQueueEntryModel({
    this.id,
    required this.opId,
    required this.entity,
    required this.op,
    this.clientId,
    this.networkId,
    this.data,
  });

  final int? id;
  final String opId;
  final String entity;
  final String op;
  final String? clientId;
  final int? networkId;
  final SyncOpDataRequestModel? data;
}
