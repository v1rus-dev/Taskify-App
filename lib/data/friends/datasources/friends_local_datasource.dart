import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/data/database/app_database.dart' as db;

abstract class FriendsLocalDataSource {
  Future<Either<Failure, List<db.FriendsTableData>>> getFriends();
  Future<Either<Failure, List<db.IncomingFriendRequestsTableData>>>
      getIncomingRequests();
  Future<Either<Failure, List<db.OutgoingFriendRequestsTableData>>>
      getOutgoingRequests();

  Future<Either<Failure, void>> replaceFriends(
    List<db.FriendsTableCompanion> companions,
  );
  Future<Either<Failure, void>> replaceIncomingRequests(
    List<db.IncomingFriendRequestsTableCompanion> companions,
  );
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<db.OutgoingFriendRequestsTableCompanion> companions,
  );

  Future<Either<Failure, void>> deleteFriendById(String friendId);
  Future<Either<Failure, void>> deleteIncomingRequest(String requestId);
  Future<Either<Failure, void>> deleteOutgoingRequest(String requestId);
}

class FriendsLocalDataSourceImpl implements FriendsLocalDataSource {
  FriendsLocalDataSourceImpl(this._database);

  final db.AppDatabase _database;

  @override
  Future<Either<Failure, List<db.FriendsTableData>>> getFriends() async {
    try {
      final rows = await _database.select(_database.friendsTable).get();
      return Right(rows);
    } catch (e) {
      TalkerService.instance.error('syncTag getFriends local error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.IncomingFriendRequestsTableData>>>
      getIncomingRequests() async {
    try {
      final rows = await _database
          .select(_database.incomingFriendRequestsTable)
          .get();
      return Right(rows);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag getIncomingRequests local error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.OutgoingFriendRequestsTableData>>>
      getOutgoingRequests() async {
    try {
      final rows = await _database
          .select(_database.outgoingFriendRequestsTable)
          .get();
      return Right(rows);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag getOutgoingRequests local error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
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
    List<db.IncomingFriendRequestsTableCompanion> companions,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteAll(_database.incomingFriendRequestsTable);
        if (companions.isNotEmpty) {
          batch.insertAll(_database.incomingFriendRequestsTable, companions);
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag replaceIncomingRequests error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<db.OutgoingFriendRequestsTableCompanion> companions,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteAll(_database.outgoingFriendRequestsTable);
        if (companions.isNotEmpty) {
          batch.insertAll(_database.outgoingFriendRequestsTable, companions);
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag replaceOutgoingRequests error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFriendById(String friendId) async {
    try {
      await (_database.delete(_database.friendsTable)
            ..where((row) => row.id.equals(friendId)))
          .go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag deleteFriendById error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIncomingRequest(String requestId) async {
    try {
      await (_database.delete(_database.incomingFriendRequestsTable)
            ..where((row) => row.requestId.equals(requestId)))
          .go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag deleteIncomingRequest error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOutgoingRequest(String requestId) async {
    try {
      await (_database.delete(_database.outgoingFriendRequestsTable)
            ..where((row) => row.requestId.equals(requestId)))
          .go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error(
        'syncTag deleteOutgoingRequest error',
        e,
      );
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
