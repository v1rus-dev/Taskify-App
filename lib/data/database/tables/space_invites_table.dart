import 'package:drift/drift.dart';

class SpaceInvitesTable extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get token => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('viewer'))();
  BoolColumn get isRevoked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
