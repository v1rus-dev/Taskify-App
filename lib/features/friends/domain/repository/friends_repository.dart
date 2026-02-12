import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/friends/domain/models/friend_entity.dart';
import 'package:taskify/features/friends/domain/models/friend_profile_entity.dart';
import 'package:taskify/features/friends/domain/models/friend_request_entity.dart';

abstract class FriendsRepository {
  Future<Either<Failure, List<FriendEntity>>> fetchFriendsRemote();
  Future<Either<Failure, FriendProfileEntity>> fetchFriendProfileRemote(
    String userId,
  );
  Future<Either<Failure, List<FriendRequestEntity>>>
  fetchIncomingRequestsRemote();
  Future<Either<Failure, List<FriendRequestEntity>>>
  fetchOutgoingRequestsRemote();
  Future<Either<Failure, void>> replaceFriends(List<FriendEntity> friends);
  Future<Either<Failure, void>> replaceIncomingRequests(
    List<FriendRequestEntity> requests,
  );
  Future<Either<Failure, void>> replaceOutgoingRequests(
    List<FriendRequestEntity> requests,
  );
  Stream<List<FriendEntity>> observeFriends();
  Stream<List<FriendRequestEntity>> observeIncomingRequests();
  Stream<List<FriendRequestEntity>> observeOutgoingRequests();
  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest(
    String friendTag,
  );
  Future<Either<Failure, FriendEntity?>> getFriendById(String friendId);
  Future<Either<Failure, void>> upsertFriend(FriendEntity friend);
  Future<Either<Failure, FriendEntity>> acceptRequest(String requestId);
  Future<Either<Failure, void>> declineRequest(String requestId);
  Future<Either<Failure, void>> cancelRequest(String requestId);
  Future<Either<Failure, void>> removeFriend(String friendId);
  Future<Either<Failure, String>> regenerateFriendTag();
}
