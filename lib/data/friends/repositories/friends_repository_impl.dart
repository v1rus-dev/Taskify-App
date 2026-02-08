import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/friends/datasources/friends_local_datasource.dart';
import 'package:taskify/data/friends/datasources/friends_network_datasource.dart';
import 'package:taskify/data/friends/mappers/friends_mapper.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_profile_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/domain/friends/repository/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl({
    required FriendsNetworkDataSource networkDataSource,
    required FriendsLocalDataSource localDataSource,
  }) : _networkDataSource = networkDataSource,
       _localDataSource = localDataSource;

  final FriendsNetworkDataSource _networkDataSource;
  final FriendsLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<FriendEntity>>> fetchFriendsRemote() async {
    final result = await _networkDataSource.getFriends();
    return result.fold(
      ifLeft: Left.new,
      ifRight: (models) =>
          Right(models.map((model) => model.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, FriendProfileEntity>> fetchFriendProfileRemote(
    String userId,
  ) async {
    final result = await _networkDataSource.getFriendProfile(userId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) => Right(
        FriendProfileEntity(
          friend: model.user.toDomain(),
          isFriend: model.isFriend,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>>
  fetchIncomingRequestsRemote() async {
    final result = await _networkDataSource.getIncomingRequests();
    return result.fold(
      ifLeft: Left.new,
      ifRight: (models) => Right(
        models.map((model) => model.toDomain(isIncoming: true)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>>
  fetchOutgoingRequestsRemote() async {
    final result = await _networkDataSource.getOutgoingRequests();
    return result.fold(
      ifLeft: Left.new,
      ifRight: (models) => Right(
        models.map((model) => model.toDomain(isIncoming: false)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> replaceFriends(List<FriendEntity> friends) {
    return _localDataSource.replaceFriends(
      friends.map((friend) => friend.toCompanion()).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> replaceIncomingRequests(
    List<FriendRequestEntity> requests,
  ) {
    return _localDataSource.replaceIncomingRequests(
      requests.map((request) => request.toCompanion(isIncoming: true)).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<FriendRequestEntity> requests,
  ) {
    return _localDataSource.replaceOutgoingRequests(
      requests
          .map((request) => request.toCompanion(isIncoming: false))
          .toList(),
    );
  }

  @override
  Stream<List<FriendEntity>> observeFriends() {
    return _localDataSource.observeFriends().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  @override
  Stream<List<FriendRequestEntity>> observeIncomingRequests() {
    return _localDataSource.observeIncomingRequests().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  @override
  Stream<List<FriendRequestEntity>> observeOutgoingRequests() {
    return _localDataSource.observeOutgoingRequests().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
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
      ifRight: (model) => request = model.toDomain(isIncoming: false),
    );
    if (failure != null) {
      return Left(failure!);
    }
    if (request == null) {
      return const Left(ServerFailure('Request not created'));
    }

    return Right(request!);
  }

  @override
  Future<Either<Failure, FriendEntity?>> getFriendById(String friendId) async {
    final result = await _localDataSource.getFriendById(friendId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (row) => Right(row?.toDomain()),
    );
  }

  @override
  Future<Either<Failure, void>> upsertFriend(FriendEntity friend) {
    return _localDataSource.upsertFriend(friend.toCompanion());
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
      return const Left(ServerFailure('Friend not returned'));
    }

    final deleteResult = await _localDataSource.deleteRequest(requestId);
    if (deleteResult.isLeft) {
      return deleteResult.fold(
        ifLeft: Left.new,
        ifRight: (_) => Right(friend!),
      );
    }

    final saveResult = await _localDataSource.upsertFriend(
      friend!.toCompanion(),
    );
    return saveResult.fold(ifLeft: Left.new, ifRight: (_) => Right(friend!));
  }

  @override
  Future<Either<Failure, void>> declineRequest(String requestId) async {
    final result = await _networkDataSource.declineRequest(requestId);
    if (result.isLeft) {
      return result;
    }
    return _localDataSource.deleteRequest(requestId);
  }

  @override
  Future<Either<Failure, void>> cancelRequest(String requestId) async {
    final result = await _networkDataSource.cancelRequest(requestId);
    if (result.isLeft) {
      return result;
    }
    return _localDataSource.deleteRequest(requestId);
  }

  @override
  Future<Either<Failure, void>> removeFriend(String friendId) async {
    final result = await _networkDataSource.removeFriend(friendId);
    if (result.isLeft) {
      return result;
    }
    return _localDataSource.deleteFriendById(friendId);
  }

  @override
  Future<Either<Failure, String>> regenerateFriendTag() async {
    final result = await _networkDataSource.regenerateFriendTag();
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) => Right(model.friendTag),
    );
  }
}
