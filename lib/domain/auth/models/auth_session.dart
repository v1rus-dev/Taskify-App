class AuthSession {
  const AuthSession({
    required this.provider,
    required this.uid,
    this.idToken,
    this.authCode,
    this.email,
    this.displayName,
  });

  final String provider;
  final String uid;
  final String? idToken;
  final String? authCode;
  final String? email;
  final String? displayName;
}
