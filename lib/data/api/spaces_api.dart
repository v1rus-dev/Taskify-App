import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/dio_client.dart';

class SpacesApi {
  SpacesApi(this._client);

  final DioClient _client;

  Future<Either<Failure, Map<String, dynamic>>> createSpace(
    Map<String, dynamic> body,
  ) {
    return _client.post(path: 'spaces', data: body, parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> listSpaces({
    String? cursor,
    int? limit,
  }) {
    return _client.get(
      path: 'spaces',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        if (limit != null) 'limit': limit,
      },
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getSpace(String spaceId) {
    return _client.get(path: 'spaces/$spaceId', parser: _parseMap);
  }

  Future<Either<Failure, void>> deleteSpace(String spaceId) {
    return _client.delete(path: 'spaces/$spaceId', parser: (_) {});
  }

  Future<Either<Failure, Map<String, dynamic>>> leaveSpace(String spaceId) {
    return _client.post(path: 'spaces/$spaceId/leave', parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> expandSpace(String spaceId) {
    return _client.post(path: 'spaces/$spaceId/expand', parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> listMembers(String spaceId) {
    return _client.get(path: 'spaces/$spaceId/members', parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> addMember(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/members',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updateMemberRole(
    String spaceId,
    String userId,
    Map<String, dynamic> body,
  ) {
    return _client.patch(
      path: 'spaces/$spaceId/members/$userId',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, void>> removeMember(String spaceId, String userId) {
    return _client.delete(
      path: 'spaces/$spaceId/members/$userId',
      parser: (_) {},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> listInvites(String spaceId) {
    return _client.get(path: 'spaces/$spaceId/invites', parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> createInvite(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/invites',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> revokeInvite(
    String spaceId,
    String inviteId,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/invites/$inviteId/revoke',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptInviteToken(
    String token,
  ) {
    return _client.post(
      path: 'spaces/invites/$token/accept',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> listLists(String spaceId) {
    return _client.get(path: 'spaces/$spaceId/lists', parser: _parseMap);
  }

  Future<Either<Failure, Map<String, dynamic>>> createList(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/lists',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> reorderLists(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/lists/reorder',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updateList(
    String spaceId,
    String listId,
    Map<String, dynamic> body,
  ) {
    return _client.patch(
      path: 'spaces/$spaceId/lists/$listId',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, void>> deleteList(String spaceId, String listId) {
    return _client.delete(
      path: 'spaces/$spaceId/lists/$listId',
      parser: (_) {},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> listTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  }) {
    return _client.get(
      path: 'spaces/$spaceId/tasks',
      queryParameters: {
        if (listId != null) 'listId': listId,
        if (cursor != null) 'cursor': cursor,
        if (limit != null) 'limit': limit,
      },
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> createTask(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getTask(
    String spaceId,
    String taskId,
  ) {
    return _client.get(
      path: 'spaces/$spaceId/tasks/$taskId',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updateTask(
    String spaceId,
    String taskId,
    Map<String, dynamic> body,
  ) {
    return _client.patch(
      path: 'spaces/$spaceId/tasks/$taskId',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, void>> deleteTask(String spaceId, String taskId) {
    return _client.delete(
      path: 'spaces/$spaceId/tasks/$taskId',
      parser: (_) {},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> claimTask(
    String spaceId,
    String taskId,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/claim',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> unclaimTask(
    String spaceId,
    String taskId,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/unclaim',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> assignTask(
    String spaceId,
    String taskId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/assign',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> completeTask(
    String spaceId,
    String taskId,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/complete',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> uncompleteTask(
    String spaceId,
    String taskId,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/uncomplete',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> listSubtasks(
    String spaceId,
    String taskId,
  ) {
    return _client.get(
      path: 'spaces/$spaceId/tasks/$taskId/subtasks',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> createSubtask(
    String spaceId,
    String taskId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/tasks/$taskId/subtasks',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updateSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
    Map<String, dynamic> body,
  ) {
    return _client.patch(
      path: 'spaces/$spaceId/tasks/$taskId/subtasks/$subtaskId',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, void>> deleteSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
  ) {
    return _client.delete(
      path: 'spaces/$spaceId/tasks/$taskId/subtasks/$subtaskId',
      parser: (_) {},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> listNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  }) {
    return _client.get(
      path: 'spaces/$spaceId/notes',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        if (limit != null) 'limit': limit,
      },
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> createNote(
    String spaceId,
    Map<String, dynamic> body,
  ) {
    return _client.post(
      path: 'spaces/$spaceId/notes',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getNote(
    String spaceId,
    String noteId,
  ) {
    return _client.get(
      path: 'spaces/$spaceId/notes/$noteId',
      parser: _parseMap,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updateNote(
    String spaceId,
    String noteId,
    Map<String, dynamic> body,
  ) {
    return _client.patch(
      path: 'spaces/$spaceId/notes/$noteId',
      data: body,
      parser: _parseMap,
    );
  }

  Future<Either<Failure, void>> deleteNote(String spaceId, String noteId) {
    return _client.delete(
      path: 'spaces/$spaceId/notes/$noteId',
      parser: (_) {},
    );
  }

  Map<String, dynamic> _parseMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {'items': data is List ? data : const <dynamic>[]};
  }
}
