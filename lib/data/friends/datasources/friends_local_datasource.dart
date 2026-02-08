import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/data/database/app_database.dart' as db;

abstract class FriendsLocalDataSource {
  Stream<List<db.FriendsTableData>> observeFriends();
  Stream<List<db.FriendRequestsTableData>> observeIncomingRequests();
  Stream<List<db.FriendRequestsTableData>> observeOutgoingRequests();
  Future<Either<Failure, db.FriendsTableData?>> getFriendById(String friendId);

  Future<Either<Failure, void>> replaceFriends(
    List<db.FriendsTableCompanion> companions,
  );
  Future<Either<Failure, void>> replaceIncomingRequests(
    List<db.FriendRequestsTableCompanion> companions,
  );
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<db.FriendRequestsTableCompanion> companions,
  );
  Future<Either<Failure, void>> upsertFriend(
    db.FriendsTableCompanion companion,
  );
  Future<Either<Failure, void>> upsertRequest(
    db.FriendRequestsTableCompanion companion,
  );

  Future<Either<Failure, void>> deleteFriendById(String friendId);
  Future<Either<Failure, void>> deleteRequest(String requestId);
}

class FriendsLocalDataSourceImpl implements FriendsLocalDataSource {
  FriendsLocalDataSourceImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<db.FriendsTableData>> observeFriends() {
    return _database
        .select(_database.friendsTable)
        .watch()
        .map((rows) => rows.toList());
  }

  @override
  Future<Either<Failure, db.FriendsTableData?>> getFriendById(
    String friendId,
  ) async {
    try {
      final query = _database.select(_database.friendsTable)
        ..where((row) => row.id.equals(friendId));
      final friend = await query.getSingleOrNull();
      return Right(friend);
    } catch (e) {
      TalkerService.instance.error('syncTag getFriendById error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.FriendRequestsTableData>> observeIncomingRequests() {
    final query = _database.select(_database.friendRequestsTable);
    query.where((row) => row.isIncoming.equals(true));
    return query.watch().map((rows) => rows.toList());
  }

  @override
  Stream<List<db.FriendRequestsTableData>> observeOutgoingRequests() {
    final query = _database.select(_database.friendRequestsTable);
    query.where((row) => row.isIncoming.equals(false));
    return query.watch().map((rows) => rows.toList());
  }

  @override
  Future<Either<Failure, void>> replaceFriends(
    List<db.FriendsTableCompanion> companions,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteAll(_database.friendsTable);
        if (companions.isNotEmpty) {
          batch.insertAll(_database.friendsTable, companions);
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag replaceFriends error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceIncomingRequests(
    List<db.FriendRequestsTableCompanion> companions,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.friendRequestsTable,
          (table) => table.isIncoming.equals(true),
        );
        if (companions.isNotEmpty) {
          batch.insertAll(_database.friendRequestsTable, companions);
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag replaceIncomingRequests error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<db.FriendRequestsTableCompanion> companions,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.friendRequestsTable,
          (table) => table.isIncoming.equals(false),
        );
        if (companions.isNotEmpty) {
          batch.insertAll(_database.friendRequestsTable, companions);
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag replaceOutgoingRequests error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFriendById(String friendId) async {
    try {
      await (_database.delete(
        _database.friendsTable,
      )..where((row) => row.id.equals(friendId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag deleteFriendById error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertFriend(
    db.FriendsTableCompanion companion,
  ) async {
    try {
      await _database
          .into(_database.friendsTable)
          .insertOnConflictUpdate(companion);
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag upsertFriend error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertRequest(
    db.FriendRequestsTableCompanion companion,
  ) async {
    try {
      await (_database.delete(
        _database.friendRequestsTable,
      )..where((row) => row.requestId.equals(companion.requestId.value))).go();
      await _database.into(_database.friendRequestsTable).insert(companion);
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag upsertRequest error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequest(String requestId) async {
    try {
      await (_database.delete(
        _database.friendRequestsTable,
      )..where((row) => row.requestId.equals(requestId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag deleteRequest error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
