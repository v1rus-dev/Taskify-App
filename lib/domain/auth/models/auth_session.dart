import 'package:taskify/domain/auth/models/auth_providers.dart';

class AuthSession {
  const AuthSession({
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

  @override
  String toString() {
    return 'AuthSession(provider: $provider, uid: $uid, idToken: $idToken, authCode: $authCode, email: $email, displayName: $displayName)';
  }
}
