import 'package:taskify/data/friends/models/friend_response_model.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';

class FriendRequestItemResponseModel {
  const FriendRequestItemResponseModel({
    required this.requestId,
    required this.user,
  });

  final String requestId;
  final FriendResponseModel user;

  factory FriendRequestItemResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestItemResponseModel(
      requestId: json['request_id'] as String,
      user: FriendResponseModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  FriendRequestEntity toDomain({required bool isIncoming}) {
    return FriendRequestEntity(
      requestId: requestId,
      user: user.toDomain(),
      isIncoming: isIncoming,
    );
  }
}
