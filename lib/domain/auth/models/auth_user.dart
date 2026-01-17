class AuthUser {
  const AuthUser({
    required this.id,
    required this.provider,
    required this.providerUserId,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.avatarUrl,
  });

  final String id;
  final String provider;
  final String providerUserId;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
}
