import 'package:taskify/data/sync/models/sync_id_map_item_response_model.dart';
import 'package:taskify/data/sync/models/sync_op_error_item_response_model.dart';

class SyncPushResponseModel {
  const SyncPushResponseModel({
    required this.ack,
    required this.idMap,
    required this.errors,
  });

  final List<String> ack;
  final Map<String, List<SyncIdMapItemResponseModel>> idMap;
  final List<SyncOpErrorItemResponseModel> errors;

  factory SyncPushResponseModel.fromJson(Map<String, dynamic> json) {
    final idMapRaw = json['id_map'] as Map<String, dynamic>? ?? {};
    final mappedIdMap = <String, List<SyncIdMapItemResponseModel>>{};
    for (final entry in idMapRaw.entries) {
      mappedIdMap[entry.key] = (entry.value as List<dynamic>)
          .map((item) => SyncIdMapItemResponseModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return SyncPushResponseModel(
      ack: (json['ack'] as List<dynamic>? ?? [])
          .map((item) => item as String)
          .toList(),
      idMap: mappedIdMap,
      errors: (json['errors'] as List<dynamic>? ?? [])
          .map((item) => SyncOpErrorItemResponseModel.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}
