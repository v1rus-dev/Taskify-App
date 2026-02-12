import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/sync/data/models/sync_changes_response_model.dart';
import 'package:taskify/features/sync/data/models/sync_op_input_request_model.dart';
import 'package:taskify/features/sync/data/models/sync_push_request_model.dart';
import 'package:taskify/features/sync/data/models/sync_push_response_model.dart';

abstract class SyncRemoteDataSource {
  Future<Either<Failure, SyncPushResponseModel>> pushChanges({
    required String deviceId,
    required List<SyncOpInputRequestModel> ops,
  });

  Future<Either<Failure, SyncChangesResponseModel>> getChanges({
    required int cursor,
    int limit,
    bool compact,
  });
}

class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  SyncRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, SyncPushResponseModel>> pushChanges({
    required String deviceId,
    required List<SyncOpInputRequestModel> ops,
  }) async {
    TalkerService.instance.info('syncTag pushChanges start: ${ops.length}');
    final request = SyncPushRequestModel(deviceId: deviceId, ops: ops);
    final result = await _client.post<SyncPushResponseModel>(
      path: '/sync/push',
      data: request.toJson(),
      parser: (data) =>
          SyncPushResponseModel.fromJson(data as Map<String, dynamic>),
    );
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag pushChanges error', failure),
      ifRight: (_) => TalkerService.instance.info('syncTag pushChanges done'),
    );
    return result;
  }

  @override
  Future<Either<Failure, SyncChangesResponseModel>> getChanges({
    required int cursor,
    int limit = 200,
    bool compact = true,
  }) async {
    TalkerService.instance.info(
      'syncTag getChanges start: cursor=$cursor limit=$limit',
    );
    final result = await _client.get<SyncChangesResponseModel>(
      path: '/sync/changes',
      queryParameters: {'cursor': cursor, 'limit': limit, 'compact': compact},
      parser: (data) =>
          SyncChangesResponseModel.fromJson(data as Map<String, dynamic>),
    );
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag getChanges error', failure),
      ifRight: (_) => TalkerService.instance.info('syncTag getChanges done'),
    );
    return result;
  }
}
