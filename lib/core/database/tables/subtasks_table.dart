import 'package:drift/drift.dart';

class SubtasksTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get networkId => integer().nullable()();
  TextColumn get clientId => text().nullable()();
  IntColumn get taskId => integer()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
