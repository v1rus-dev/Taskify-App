import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/api/friends_api.dart';
import 'package:taskify/data/friends/models/friend_profile_response_model.dart';
import 'package:taskify/data/friends/models/friend_request_item_response_model.dart';
import 'package:taskify/data/friends/models/friend_response_model.dart';
import 'package:taskify/data/friends/models/friend_tag_response_model.dart';

abstract class FriendsNetworkDataSource {
  Future<Either<Failure, FriendTagResponseModel>> regenerateFriendTag();
  Future<Either<Failure, List<FriendResponseModel>>> getFriends();
  Future<Either<Failure, FriendProfileResponseModel>> getFriendProfile(
    String userId,
  );
  Future<Either<Failure, FriendRequestItemResponseModel>> sendFriendRequest(
    String friendTag,
  );
  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getIncomingRequests();
  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getOutgoingRequests();
  Future<Either<Failure, FriendResponseModel>> acceptRequest(String requestId);
  Future<Either<Failure, void>> declineRequest(String requestId);
  Future<Either<Failure, void>> cancelRequest(String requestId);
  Future<Either<Failure, void>> removeFriend(String friendId);
}

class FriendsNetworkDataSourceImpl implements FriendsNetworkDataSource {
  FriendsNetworkDataSourceImpl(this._api);

  final FriendsApi _api;

  @override
  Future<Either<Failure, FriendTagResponseModel>> regenerateFriendTag() {
    return _api.regenerateFriendTag();
  }

  @override
  Future<Either<Failure, List<FriendResponseModel>>> getFriends() {
    return _api.getFriends();
  }

  @override
  Future<Either<Failure, FriendProfileResponseModel>> getFriendProfile(
    String userId,
  ) {
    return _api.getFriendProfile(userId: userId);
  }

  @override
  Future<Either<Failure, FriendRequestItemResponseModel>> sendFriendRequest(
    String friendTag,
  ) {
    return _api.sendFriendRequest(friendTag: friendTag);
  }

  @override
  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getIncomingRequests() {
    return _api.getIncomingRequests();
  }

  @override
  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getOutgoingRequests() {
    return _api.getOutgoingRequests();
  }

  @override
  Future<Either<Failure, FriendResponseModel>> acceptRequest(String requestId) {
    return _api.acceptRequest(requestId: requestId);
  }

  @override
  Future<Either<Failure, void>> declineRequest(String requestId) {
    return _api.declineRequest(requestId: requestId);
  }

  @override
  Future<Either<Failure, void>> cancelRequest(String requestId) {
    return _api.cancelRequest(requestId: requestId);
  }

  @override
  Future<Either<Failure, void>> removeFriend(String friendId) {
    return _api.removeFriend(friendId: friendId);
  }
}
