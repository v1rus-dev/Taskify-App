import 'package:drift/drift.dart';

class FriendsTable extends Table {
  TextColumn get id => text()();
  TextColumn get friendTag => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get anonymousNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
