import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';

abstract class AuthTokenHandler {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<Either<Failure, void>> saveTokens({
    required String accessToken,
    String? refreshToken,
  });
  Future<Either<Failure, void>> clearTokens();
}
