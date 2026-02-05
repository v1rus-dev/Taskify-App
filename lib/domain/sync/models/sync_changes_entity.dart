import 'package:taskify/domain/sync/models/sync_change_entity.dart';

class SyncChangesEntity {
  const SyncChangesEntity({
    required this.nextCursor,
    required this.changes,
  });

  final int nextCursor;
  final List<SyncChangeEntity> changes;
}
