import 'package:taskify/features/sync/data/models/sync_event_item_response_model.dart';

class SyncChangesResponseModel {
  const SyncChangesResponseModel({
    required this.nextCursor,
    required this.changes,
  });

  final int nextCursor;
  final List<SyncEventItemResponseModel> changes;

  factory SyncChangesResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncChangesResponseModel(
      nextCursor: json['next_cursor'] as int,
      changes: (json['changes'] as List<dynamic>)
          .map(
            (item) => SyncEventItemResponseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
