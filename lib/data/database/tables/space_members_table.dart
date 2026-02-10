import 'package:drift/drift.dart';

class SpaceMembersTable extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get spaceId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('viewer'))();
  DateTimeColumn get joinedAt => dateTime().nullable()();
}
