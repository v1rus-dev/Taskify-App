import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/features/friends/data/models/friend_profile_response_model.dart';
import 'package:taskify/features/friends/data/models/friend_request_item_response_model.dart';
import 'package:taskify/features/friends/data/models/friend_response_model.dart';
import 'package:taskify/features/friends/data/models/friend_tag_response_model.dart';

class FriendsApi {
  FriendsApi(this._client);

  final DioClient _client;

  Future<Either<Failure, FriendTagResponseModel>> regenerateFriendTag() {
    return _client.put(
      path: 'friends/tag',
      parser: (data) =>
          FriendTagResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Either<Failure, List<FriendResponseModel>>> getFriends() {
    return _client.get(
      path: 'friends',
      parser: (data) => (data as List<dynamic>)
          .map(
            (item) =>
                FriendResponseModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<Either<Failure, FriendProfileResponseModel>> getFriendProfile({
    required String userId,
  }) {
    return _client.get(
      path: 'friends/$userId',
      parser: (data) =>
          FriendProfileResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Either<Failure, FriendRequestItemResponseModel>> sendFriendRequest({
    required String friendTag,
  }) {
    return _client.post(
      path: 'friends/requests',
      data: {'friend_tag': friendTag},
      parser: (data) =>
          FriendRequestItemResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getIncomingRequests() {
    return _client.get(
      path: 'friends/requests/incoming',
      parser: (data) => (data as List<dynamic>)
          .map(
            (item) => FriendRequestItemResponseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Future<Either<Failure, List<FriendRequestItemResponseModel>>>
  getOutgoingRequests() {
    return _client.get(
      path: 'friends/requests/outgoing',
      parser: (data) => (data as List<dynamic>)
          .map(
            (item) => FriendRequestItemResponseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Future<Either<Failure, FriendResponseModel>> acceptRequest({
    required String requestId,
  }) {
    return _client.post(
      path: 'friends/requests/accept',
      data: {'request_id': requestId},
      parser: (data) =>
          FriendResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Either<Failure, void>> declineRequest({required String requestId}) {
    return _client.post(
      path: 'friends/requests/decline',
      data: {'request_id': requestId},
      parser: (_) {},
    );
  }

  Future<Either<Failure, void>> cancelRequest({required String requestId}) {
    return _client.post(
      path: 'friends/requests/cancel',
      data: {'request_id': requestId},
      parser: (_) {},
    );
  }

  Future<Either<Failure, void>> removeFriend({required String friendId}) {
    return _client.delete(path: 'friends/$friendId', parser: (_) {});
  }
}
