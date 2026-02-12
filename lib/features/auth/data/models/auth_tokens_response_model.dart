class AuthTokensResponseModel {
  const AuthTokensResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  factory AuthTokensResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
