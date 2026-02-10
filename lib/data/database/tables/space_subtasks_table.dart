import 'package:drift/drift.dart';

class SpaceSubtasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
