import 'package:drift/drift.dart';

class OutgoingFriendRequestsTable extends Table {
  TextColumn get requestId => text()();
  TextColumn get userId => text()();
  TextColumn get userName => text().nullable()();
  TextColumn get userImageUrl => text().nullable()();
  TextColumn get userDisplayName => text()();

  @override
  Set<Column> get primaryKey => {requestId};
}
