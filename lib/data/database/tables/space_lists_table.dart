import 'package:drift/drift.dart';

class SpaceListsTable extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  IntColumn get order => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
