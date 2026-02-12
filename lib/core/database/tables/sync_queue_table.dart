import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get opId => text()();
  TextColumn get entity => text()();
  TextColumn get op => text()();
  TextColumn get clientId => text().nullable()();
  IntColumn get networkId => integer().nullable()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
