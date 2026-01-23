import 'package:taskify/domain/sync/models/sync_change.dart';

class SyncChanges {
  const SyncChanges({
    required this.nextCursor,
    required this.changes,
  });

  final int nextCursor;
  final List<SyncChange> changes;
}
