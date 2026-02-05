class AuthUserEntity {
  const AuthUserEntity({
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
}
