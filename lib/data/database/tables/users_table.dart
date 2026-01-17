import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get provider => text()();
  TextColumn get providerUserId => text()();
  TextColumn get email => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
