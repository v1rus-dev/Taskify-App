import 'package:drift/drift.dart';

class SyncStateTable extends Table {
  static const int defaultId = 0;

  IntColumn get id =>
      integer().withDefault(const Constant(SyncStateTable.defaultId))();
  TextColumn get deviceId => text().nullable()();
  IntColumn get lastCursor => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
