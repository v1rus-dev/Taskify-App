import 'package:taskify/domain/sync/models/sync_id_map.dart';
import 'package:taskify/domain/sync/models/sync_op_error.dart';

class SyncPushResult {
  const SyncPushResult({
    required this.ack,
    required this.idMap,
    required this.errors,
  });

  final List<String> ack;
  final Map<String, List<SyncIdMap>> idMap;
  final List<SyncOpError> errors;
}
