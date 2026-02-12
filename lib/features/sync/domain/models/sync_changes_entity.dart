import 'package:taskify/features/sync/domain/models/sync_change_entity.dart';

class SyncChangesEntity {
  const SyncChangesEntity({required this.nextCursor, required this.changes});

  final int nextCursor;
  final List<SyncChangeEntity> changes;
}
