import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/domain/friends/repository/friends_repository.dart';

class FriendsInteractor {
  FriendsInteractor(this._repository);

  final FriendsRepository _repository;

  Future<Either<Failure, void>> getFriends() async {
    final remoteResult = await _repository.fetchFriendsRemote();
    List<FriendEntity>? friends;
    Failure? failure;
    remoteResult.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => friends = right,
    );
    if (failure != null) {
      return Left(failure!);
    }
    return _repository.replaceFriends(friends ?? const <FriendEntity>[]);
  }

  Future<Either<Failure, void>> getFriendRequests() async {
    final incomingFuture = _repository.fetchIncomingRequestsRemote();
    final outgoingFuture = _repository.fetchOutgoingRequestsRemote();
    final incomingResult = await incomingFuture;
    final outgoingResult = await outgoingFuture;

    Failure? failure;
    List<FriendRequestEntity>? incomingRequests;
    List<FriendRequestEntity>? outgoingRequests;

    incomingResult.fold(
      ifLeft: (left) => failure ??= left,
      ifRight: (right) => incomingRequests = right,
    );
    outgoingResult.fold(
      ifLeft: (left) => failure ??= left,
      ifRight: (right) => outgoingRequests = right,
    );

    if (incomingRequests != null) {
      final saveIncomingResult = await _repository.replaceIncomingRequests(
        incomingRequests!,
      );
      saveIncomingResult.fold(
        ifLeft: (left) => failure ??= left,
        ifRight: (_) {},
      );
    }

    if (outgoingRequests != null) {
      final saveOutgoingResult = await _repository.replaceOutgoingRequests(
        outgoingRequests!,
      );
      saveOutgoingResult.fold(
        ifLeft: (left) => failure ??= left,
        ifRight: (_) {},
      );
    }

    if (failure != null) {
      return Left(failure!);
    }

    return const Right(null);
  }

  Stream<List<FriendEntity>> observeFriends() {
    return _repository.observeFriends();
  }

  Stream<List<FriendRequestEntity>> observeIncomingRequests() {
    return _repository.observeIncomingRequests();
  }

  Stream<List<FriendRequestEntity>> observeOutgoingRequests() {
    return _repository.observeOutgoingRequests();
  }

  Future<Either<Failure, void>> _refreshAfterMutation({
    required bool refreshFriends,
    required bool refreshRequests,
  }) async {
    Failure? failure;
    if (refreshFriends) {
      final refreshFriendsResult = await getFriends();
      refreshFriendsResult.fold(
        ifLeft: (left) => failure ??= left,
        ifRight: (_) {},
      );
    }
    if (refreshRequests) {
      final refreshRequestsResult = await getFriendRequests();
      refreshRequestsResult.fold(
        ifLeft: (left) => failure ??= left,
        ifRight: (_) {},
      );
    }
    if (failure != null) {
      return Left(failure!);
    }
    return const Right(null);
  }

  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest(
    String friendTag,
  ) async {
    final sendResult = await _repository.sendFriendRequest(friendTag);
    Failure? failure;
    FriendRequestEntity? request;
    sendResult.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => request = right,
    );
    if (failure != null) {
      return Left(failure!);
    }
    if (request == null) {
      return const Left(ServerFailure('Request not created'));
    }

    final refreshResult = await getFriendRequests();
    refreshResult.fold(ifLeft: (left) => failure = left, ifRight: (_) {});
    if (failure != null) {
      return Left(failure!);
    }
    return Right(request!);
  }

  Future<Either<Failure, FriendEntity>> acceptRequest(String requestId) {
    return _repository.acceptRequest(requestId).then((result) async {
      Failure? failure;
      FriendEntity? friend;
      result.fold(
        ifLeft: (left) => failure = left,
        ifRight: (right) => friend = right,
      );
      if (failure != null) {
        return Left(failure!);
      }
      if (friend == null) {
        return const Left(ServerFailure('Friend not returned'));
      }
      final refreshResult = await _refreshAfterMutation(
        refreshFriends: true,
        refreshRequests: true,
      );
      if (refreshResult.isLeft) {
        return refreshResult.fold(
          ifLeft: Left.new,
          ifRight: (_) => Right(friend!),
        );
      }
      return Right(friend!);
    });
  }

  Future<Either<Failure, void>> declineRequest(String requestId) async {
    final result = await _repository.declineRequest(requestId);
    if (result.isLeft) {
      return result;
    }
    return _refreshAfterMutation(refreshFriends: false, refreshRequests: true);
  }

  Future<Either<Failure, void>> cancelRequest(String requestId) async {
    final result = await _repository.cancelRequest(requestId);
    if (result.isLeft) {
      return result;
    }
    return _refreshAfterMutation(refreshFriends: false, refreshRequests: true);
  }

  Future<Either<Failure, void>> removeFriend(String friendId) async {
    final result = await _repository.removeFriend(friendId);
    if (result.isLeft) {
      return result;
    }
    return _refreshAfterMutation(refreshFriends: true, refreshRequests: false);
  }

  Future<Either<Failure, String>> regenerateFriendTag() {
    return _repository.regenerateFriendTag();
  }
}
