import 'package:taskify/features/auth/domain/models/auth_providers.dart';

class AuthSessionEntity {
  const AuthSessionEntity({
    required this.provider,
    required this.uid,
    this.idToken,
    this.authCode,
    this.email,
    this.displayName,
  });

  final AuthProviders provider;
  final String uid;
  final String? idToken;
  final String? authCode;
  final String? email;
  final String? displayName;
}
