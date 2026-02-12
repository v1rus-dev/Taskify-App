import 'package:taskify/features/friends/domain/models/friend_entity.dart';

class FriendResponseModel {
  const FriendResponseModel({
    required this.id,
    required this.friendTag,
    this.name,
    this.avatarUrl,
    this.anonymousNumber,
  });

  final String id;
  final String friendTag;
  final String? name;
  final String? avatarUrl;
  final String? anonymousNumber;

  factory FriendResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendResponseModel(
      id: json['id'] as String,
      friendTag: json['friend_tag'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      anonymousNumber: json['anonymous_number'] as String?,
    );
  }

  FriendEntity toDomain() {
    return FriendEntity(
      id: id,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      anonymousNumber: anonymousNumber,
    );
  }
}
