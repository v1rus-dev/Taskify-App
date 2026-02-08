import 'package:taskify/data/friends/models/friend_response_model.dart';

class FriendProfileResponseModel {
  const FriendProfileResponseModel({
    required this.isFriend,
    required this.user,
  });

  final bool isFriend;
  final FriendResponseModel user;

  factory FriendProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendProfileResponseModel(
      isFriend: json['is_friend'] as bool? ?? false,
      user: FriendResponseModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
