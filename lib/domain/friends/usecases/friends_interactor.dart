import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/domain/friends/repository/friends_repository.dart';

class FriendsInteractor {
  FriendsInteractor(this._repository);

  final FriendsRepository _repository;

  Future<Either<Failure, List<FriendEntity>>> getFriends() {
    return _repository.getFriends();
  }

  Future<Either<Failure, List<FriendRequestEntity>>> getIncomingRequests() {
    return _repository.getIncomingRequests();
  }

  Future<Either<Failure, List<FriendRequestEntity>>> getOutgoingRequests() {
    return _repository.getOutgoingRequests();
  }

  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest(
    String friendTag,
  ) {
    return _repository.sendFriendRequest(friendTag);
  }

  Future<Either<Failure, FriendEntity>> acceptRequest(String requestId) {
    return _repository.acceptRequest(requestId);
  }

  Future<Either<Failure, void>> declineRequest(String requestId) {
    return _repository.declineRequest(requestId);
  }

  Future<Either<Failure, void>> cancelRequest(String requestId) {
    return _repository.cancelRequest(requestId);
  }

  Future<Either<Failure, void>> removeFriend(String friendId) {
    return _repository.removeFriend(friendId);
  }

  Future<Either<Failure, String>> regenerateFriendTag() {
    return _repository.regenerateFriendTag();
  }
}
