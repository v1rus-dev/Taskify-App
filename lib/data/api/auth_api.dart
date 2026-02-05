import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/data/auth/models/auth_tokens_response_model.dart';

class AuthApi {
  AuthApi(this._client);

  final DioClient _client;

  Future<Either<Failure, T>> authenticate<T>({
    required String provider,
    required String idToken,
    T Function(dynamic data)? parser,
  }) {
    return _client.post(
      path: 'auth',
      data: {
        'provider': provider,
        'id_token': idToken,
      },
      parser: parser,
    );
  }

  Future<Either<Failure, AuthTokensResponseModel>> refresh({
    required String refreshToken,
  }) {
    return _client.post(
      path: 'auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
      parser: (data) => AuthTokensResponseModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
