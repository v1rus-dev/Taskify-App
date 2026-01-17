import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/preferences/app_preferences.dart';

class AuthTokenStorage implements AuthTokenHandler {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  @override
  Future<String?> getAccessToken() async {
    return AppPreferences.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return AppPreferences.getString(_refreshTokenKey);
  }

  @override
  Future<Either<Failure, void>> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      final savedAccess =
          await AppPreferences.setString(_accessTokenKey, accessToken);
      if (!savedAccess) {
        return const Left(CacheFailure('Failed to save access token'));
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final savedRefresh =
            await AppPreferences.setString(_refreshTokenKey, refreshToken);
        if (!savedRefresh) {
          return const Left(CacheFailure('Failed to save refresh token'));
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearTokens() async {
    try {
      final hasAccess = AppPreferences.containsKey(_accessTokenKey);
      final hasRefresh = AppPreferences.containsKey(_refreshTokenKey);
      final removedAccess =
          !hasAccess || await AppPreferences.remove(_accessTokenKey);
      final removedRefresh =
          !hasRefresh || await AppPreferences.remove(_refreshTokenKey);
      if (!removedAccess || !removedRefresh) {
        return const Left(CacheFailure('Failed to clear auth tokens'));
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
