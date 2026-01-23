import 'package:taskify/data/sync/models/sync_event_model.dart';

class SyncChangesModel {
  const SyncChangesModel({
    required this.nextCursor,
    required this.changes,
  });

  final int nextCursor;
  final List<SyncEventModel> changes;

  factory SyncChangesModel.fromJson(Map<String, dynamic> json) {
    return SyncChangesModel(
      nextCursor: json['next_cursor'] as int,
      changes: (json['changes'] as List<dynamic>)
          .map((item) => SyncEventModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
