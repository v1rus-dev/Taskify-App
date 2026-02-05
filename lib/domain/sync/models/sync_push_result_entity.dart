import 'package:taskify/domain/sync/models/sync_id_map_entity.dart';
import 'package:taskify/domain/sync/models/sync_op_error_entity.dart';

class SyncPushResultEntity {
  const SyncPushResultEntity({
    required this.ack,
    required this.idMap,
    required this.errors,
  });

  final List<String> ack;
  final Map<String, List<SyncIdMapEntity>> idMap;
  final List<SyncOpErrorEntity> errors;
}
