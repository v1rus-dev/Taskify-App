import 'package:taskify/domain/auth/models/auth_user.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.provider,
    required this.providerUserId,
    required this.email,
    required this.friendTag,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.avatarUrl,
  });

  final String id;
  final String provider;
  final String providerUserId;
  final String email;
  final String friendTag;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      provider: json['provider'] as String,
      providerUserId: json['provider_user_id'] as String,
      email: json['email'] as String,
      friendTag: json['friend_tag'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      provider: provider,
      providerUserId: providerUserId,
      email: email,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
