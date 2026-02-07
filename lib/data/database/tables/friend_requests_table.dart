import 'package:drift/drift.dart';

class FriendRequestsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get requestId => text()();
  TextColumn get userId => text()();
  TextColumn get friendTag => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get anonymousNumber => text().nullable()();
  BoolColumn get isIncoming => boolean().withDefault(const Constant(false))();
}