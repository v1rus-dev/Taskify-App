import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/data/friends/datasources/friends_local_datasource.dart';
import 'package:taskify/data/friends/datasources/friends_network_datasource.dart';
import 'package:taskify/data/friends/mappers/friends_mapper.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/domain/friends/repository/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl({
    required FriendsNetworkDataSource networkDataSource,
    required FriendsLocalDataSource localDataSource,
  })  : _networkDataSource = networkDataSource,
        _localDataSource = localDataSource;

  final FriendsNetworkDataSource _networkDataSource;
  final FriendsLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends() async {
    final localResult = await _localDataSource.getFriends();
    List<FriendEntity> localFriends = const [];
    localResult.fold(
      ifLeft: (_) => localFriends = const [],
      ifRight: (rows) =>
          localFriends = rows.map((row) => row.toDomain()).toList(),
    );

    final remoteResult = await _networkDataSource.getFriends();
    Failure? remoteFailure;
    var remoteFriends = const <FriendEntity>[];
    remoteResult.fold(
      ifLeft: (failure) => remoteFailure = failure,
      ifRight: (models) {
        remoteFriends = models.map((model) => model.toDomain()).toList();
      },
    );

    if (remoteFailure != null) {
      if (localFriends.isNotEmpty) {
        return Right(localFriends);
      }
      return Left(remoteFailure!);
    }

    await _localDataSource.replaceFriends(
      remoteResult.fold(
        ifLeft: (_) => const [],
        ifRight: (models) =>
            models.map((model) => model.toCompanion()).toList(),
      ),
    );

    return Right(remoteFriends);
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> getIncomingRequests() async {
    final localResult = await _localDataSource.getIncomingRequests();
    List<FriendRequestEntity> localRequests = const [];
    localResult.fold(
      ifLeft: (_) => localRequests = const [],
      ifRight: (rows) =>
          localRequests = rows.map((row) => row.toDomain()).toList(),
    );

    final remoteResult = await _networkDataSource.getIncomingRequests();
    Failure? remoteFailure;
    var remoteRequests = const <FriendRequestEntity>[];
    remoteResult.fold(
      ifLeft: (failure) => remoteFailure = failure,
      ifRight: (models) {
        remoteRequests = models.map((model) => model.toDomain()).toList();
      },
    );

    if (remoteFailure != null) {
      if (localRequests.isNotEmpty) {
        return Right(localRequests);
      }
      return Left(remoteFailure!);
    }

    await _localDataSource.replaceIncomingRequests(
      remoteResult.fold(
        ifLeft: (_) => const [],
        ifRight: (models) =>
            models.map((model) => model.toIncomingCompanion()).toList(),
      ),
    );

    return Right(remoteRequests);
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> getOutgoingRequests() async {
    final localResult = await _localDataSource.getOutgoingRequests();
    List<FriendRequestEntity> localRequests = const [];
    localResult.fold(
      ifLeft: (_) => localRequests = const [],
      ifRight: (rows) =>
          localRequests = rows.map((row) => row.toDomain()).toList(),
    );

    final remoteResult = await _networkDataSource.getOutgoingRequests();
    Failure? remoteFailure;
    var remoteRequests = const <FriendRequestEntity>[];
    remoteResult.fold(
      ifLeft: (failure) => remoteFailure = failure,
      ifRight: (models) {
        remoteRequests = models.map((model) => model.toDomain()).toList();
      },
    );

    if (remoteFailure != null) {
      if (localRequests.isNotEmpty) {
        return Right(localRequests);
      }
      return Left(remoteFailure!);
    }

    await _localDataSource.replaceOutgoingRequests(
      remoteResult.fold(
        ifLeft: (_) => const [],
        ifRight: (models) =>
            models.map((model) => model.toOutgoingCompanion()).toList(),
      ),
    );

    return Right(remoteRequests);
  }

  @override
  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest(
    String friendTag,
  ) async {
    final result = await _networkDataSource.sendFriendRequest(friendTag);
    Failure? failure;
    FriendRequestEntity? request;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (model) => request = model.toDomain(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    if (request == null) {
      return Left(const ServerFailure('Request not created'));
    }

    final localResult = await _localDataSource.getOutgoingRequests();
    final companions = <db.OutgoingFriendRequestsTableCompanion>[];
    final existingIds = <String>{};
    localResult.fold(
      ifLeft: (_) {},
      ifRight: (rows) {
        for (final row in rows) {
          existingIds.add(row.requestId);
          companions.add(row.toCompanion(true));
        }
      },
    );
    result.fold(
      ifLeft: (_) {},
      ifRight: (model) {
        if (!existingIds.contains(model.requestId)) {
          companions.add(model.toOutgoingCompanion());
        }
      },
    );
    await _localDataSource.replaceOutgoingRequests(companions);

    return Right(request!);
  }

  @override
  Future<Either<Failure, FriendEntity>> acceptRequest(String requestId) async {
    final result = await _networkDataSource.acceptRequest(requestId);
    Failure? failure;
    FriendEntity? friend;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (model) => friend = model.toDomain(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    if (friend == null) {
      return Left(const ServerFailure('Friend not returned'));
    }

    await _localDataSource.deleteIncomingRequest(requestId);
    final localResult = await _localDataSource.getFriends();
    final companions = <db.FriendsTableCompanion>[];
    final existingIds = <String>{};
    localResult.fold(
      ifLeft: (_) {},
      ifRight: (rows) {
        for (final row in rows) {
          existingIds.add(row.id);
          companions.add(row.toCompanion(true));
        }
      },
    );
    result.fold(
      ifLeft: (_) {},
      ifRight: (model) {
        if (!existingIds.contains(model.id)) {
          companions.add(model.toCompanion());
        }
      },
    );
    await _localDataSource.replaceFriends(companions);

    return Right(friend!);
  }

  @override
  Future<Either<Failure, void>> declineRequest(String requestId) async {
    final result = await _networkDataSource.declineRequest(requestId);
    Failure? failure;
    result.fold(ifLeft: (left) => failure = left, ifRight: (_) {});
    if (failure != null) {
      return Left(failure!);
    }
    await _localDataSource.deleteIncomingRequest(requestId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> cancelRequest(String requestId) async {
    final result = await _networkDataSource.cancelRequest(requestId);
    Failure? failure;
    result.fold(ifLeft: (left) => failure = left, ifRight: (_) {});
    if (failure != null) {
      return Left(failure!);
    }
    await _localDataSource.deleteOutgoingRequest(requestId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> removeFriend(String friendId) async {
    final result = await _networkDataSource.removeFriend(friendId);
    Failure? failure;
    result.fold(ifLeft: (left) => failure = left, ifRight: (_) {});
    if (failure != null) {
      return Left(failure!);
    }
    await _localDataSource.deleteFriendById(friendId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> regenerateFriendTag() async {
    final result = await _networkDataSource.regenerateFriendTag();
    Failure? failure;
    String? friendTag;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (model) => friendTag = model.friendTag,
    );
    if (failure != null) {
      return Left(failure!);
    }
    if (friendTag == null) {
      return Left(const ServerFailure('Friend tag not returned'));
    }
    return Right(friendTag!);
  }
}
