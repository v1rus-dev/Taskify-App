import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';

abstract class FriendsRepository {
  Future<Either<Failure, List<FriendEntity>>> getFriends();
  Future<Either<Failure, List<FriendRequestEntity>>> getIncomingRequests();
  Future<Either<Failure, List<FriendRequestEntity>>> getOutgoingRequests();
  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest(
    String friendTag,
  );
  Future<Either<Failure, FriendEntity>> acceptRequest(String requestId);
  Future<Either<Failure, void>> declineRequest(String requestId);
  Future<Either<Failure, void>> cancelRequest(String requestId);
  Future<Either<Failure, void>> removeFriend(String friendId);
  Future<Either<Failure, String>> regenerateFriendTag();
}
