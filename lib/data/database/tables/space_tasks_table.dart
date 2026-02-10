import 'package:drift/drift.dart';

class SpaceTasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get listId => text().nullable()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get assigneeId => text().nullable()();
  TextColumn get claimedById => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
