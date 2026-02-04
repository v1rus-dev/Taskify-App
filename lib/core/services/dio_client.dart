import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/network/api_result.dart';
import 'package:taskify/core/config/server_env.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'dart:async';

class DioClient {
  DioClient({
    required ServerEnv serverEnv,
    AuthTokenHandler? authTokenHandler,
  })  : _dio = _buildDio(serverEnv, authTokenHandler);

  final Dio _dio;

  static Dio _buildDio(
    ServerEnv serverEnv,
    AuthTokenHandler? authTokenHandler,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: serverEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      TalkerDioLogger(
        talker: TalkerService.instance,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printRequestData: true,
          printResponseMessage: true,
          printResponseData: true,
        ),
      ),
    );

    if (authTokenHandler != null) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final path = options.path;
            if (path.startsWith('/auth') || path.startsWith('/auth/refresh')) {
              handler.next(options);
              return;
            }
            final token = await authTokenHandler.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              TalkerService.instance.info(
                'syncTag auth header attached',
              );
            } else {
              TalkerService.instance.info(
                'syncTag auth header missing',
              );
            }
            handler.next(options);
          },
        ),
      );
    }

    return dio;
  }

  Future<ApiResult<T>> post<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      TalkerService.instance.info('syncTag POST $path');
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final parsed = parser != null
          ? parser(response.data)
          : response.data as T;
      return Right(parsed);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on TypeError catch (e) {
      return Left(ServerFailure('Response parse error: $e'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<T>> put<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      TalkerService.instance.info('syncTag PUT $path');
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final parsed = parser != null
          ? parser(response.data)
          : response.data as T;
      return Right(parsed);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on TypeError catch (e) {
      return Left(ServerFailure('Response parse error: $e'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? parser,
  }) async {
    try {
      TalkerService.instance.info('syncTag GET $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      final parsed = parser != null
          ? parser(response.data)
          : response.data as T;
      return Right(parsed);
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on TypeError catch (e) {
      return Left(ServerFailure('Response parse error: $e'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == null) {
          return const ServerFailure();
        }
        return ServerFailure('Server error: $statusCode');
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const ServerFailure();
    }
  }
}
