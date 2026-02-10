import 'package:drift/drift.dart';

class SpaceNotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get body => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
