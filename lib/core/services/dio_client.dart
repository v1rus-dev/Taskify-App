import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/network/api_result.dart';
import 'package:taskify/core/utils/api_config.dart';
import 'package:taskify/core/services/talker_service.dart';

class DioClient {
  DioClient() : _dio = _buildDio();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _buildDio() {
    if (apiBaseUrl.isEmpty) {
      throw StateError('API_BASE_URL is not set');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
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
      TalkerService.instance.info('POST $path');
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
