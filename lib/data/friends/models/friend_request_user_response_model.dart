import 'package:taskify/domain/friends/models/friend_request_user_entity.dart';

class FriendRequestUserResponseModel {
  const FriendRequestUserResponseModel({
    required this.id,
    required this.displayName,
    this.name,
    this.imageUrl,
  });

  final String id;
  final String displayName;
  final String? name;
  final String? imageUrl;

  factory FriendRequestUserResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestUserResponseModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  FriendRequestUserEntity toDomain() {
    return FriendRequestUserEntity(
      id: id,
      displayName: displayName,
      name: name,
      imageUrl: imageUrl,
    );
  }
}
