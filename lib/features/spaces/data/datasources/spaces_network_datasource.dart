import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/api/spaces_api.dart';
import 'package:taskify/features/spaces/data/models/spaces_models.dart';

abstract class SpacesNetworkDataSource {
  Future<Either<Failure, PagedResultModel<SpaceModel>>> listSpaces({
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceModel>> createSpace(
    SpaceCreateRequestModel request,
  );
  Future<Either<Failure, SpaceModel>> getSpace(String spaceId);
  Future<Either<Failure, void>> deleteSpace(String spaceId);
  Future<Either<Failure, void>> leaveSpace(String spaceId);
  Future<Either<Failure, SpaceModel>> expandSpace(String spaceId);

  Future<Either<Failure, List<SpaceMemberModel>>> listMembers(String spaceId);
  Future<Either<Failure, SpaceMemberModel>> addMember(
    String spaceId,
    SpaceMemberCreateRequestModel request,
  );
  Future<Either<Failure, SpaceMemberModel>> updateMemberRole(
    String spaceId,
    String userId,
    SpaceMemberRoleUpdateRequestModel request,
  );
  Future<Either<Failure, void>> removeMember(String spaceId, String userId);

  Future<Either<Failure, List<SpaceInviteModel>>> listInvites(String spaceId);
  Future<Either<Failure, SpaceInviteModel>> createInvite(
    String spaceId,
    SpaceInviteCreateRequestModel request,
  );
  Future<Either<Failure, SpaceInviteModel>> revokeInvite(
    String spaceId,
    String inviteId,
  );
  Future<Either<Failure, SpaceModel>> acceptInviteToken(String token);

  Future<Either<Failure, List<SpaceListModel>>> listLists(String spaceId);
  Future<Either<Failure, SpaceListModel>> createList(
    String spaceId,
    SpaceTaskListCreateRequestModel request,
  );
  Future<Either<Failure, List<SpaceListModel>>> reorderLists(
    String spaceId,
    SpaceTaskListReorderRequestModel request,
  );
  Future<Either<Failure, SpaceListModel>> updateList(
    String spaceId,
    String listId,
    SpaceTaskListUpdateRequestModel request,
  );
  Future<Either<Failure, void>> deleteList(String spaceId, String listId);

  Future<Either<Failure, PagedResultModel<SpaceTaskModel>>> listTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceTaskModel>> createTask(
    String spaceId,
    SpaceTaskCreateRequestModel request,
  );
  Future<Either<Failure, SpaceTaskModel>> getTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskModel>> updateTask(
    String spaceId,
    String taskId,
    SpaceTaskUpdateRequestModel request,
  );
  Future<Either<Failure, void>> deleteTask(String spaceId, String taskId);
  Future<Either<Failure, SpaceTaskModel>> claimTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskModel>> unclaimTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskModel>> assignTask(
    String spaceId,
    String taskId,
    SpaceTaskAssignRequestModel request,
  );
  Future<Either<Failure, SpaceTaskModel>> completeTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskModel>> uncompleteTask(
    String spaceId,
    String taskId,
  );

  Future<Either<Failure, List<SpaceSubTaskModel>>> listSubtasks(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceSubTaskModel>> createSubtask(
    String spaceId,
    String taskId,
    SpaceSubTaskCreateRequestModel request,
  );
  Future<Either<Failure, SpaceSubTaskModel>> updateSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
    SpaceSubTaskUpdateRequestModel request,
  );
  Future<Either<Failure, void>> deleteSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
  );

  Future<Either<Failure, PagedResultModel<SpaceNoteModel>>> listNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceNoteModel>> createNote(
    String spaceId,
    SpaceNoteCreateRequestModel request,
  );
  Future<Either<Failure, SpaceNoteModel>> getNote(
    String spaceId,
    String noteId,
  );
  Future<Either<Failure, SpaceNoteModel>> updateNote(
    String spaceId,
    String noteId,
    SpaceNoteUpdateRequestModel request,
  );
  Future<Either<Failure, void>> deleteNote(String spaceId, String noteId);
}

class SpacesNetworkDataSourceImpl implements SpacesNetworkDataSource {
  SpacesNetworkDataSourceImpl(this._api);

  final SpacesApi _api;

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> json) {
    final dynamic raw = json['items'] ?? json['data'] ?? json['results'];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _extractSingle(Map<String, dynamic> json) {
    final nested = json['item'] ?? json['data'] ?? json['space'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }
    return json;
  }

  @override
  Future<Either<Failure, PagedResultModel<SpaceModel>>> listSpaces({
    String? cursor,
    int? limit,
  }) async {
    final result = await _api.listSpaces(cursor: cursor, limit: limit);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) =>
          Right(PagedResultModel.fromJson(json, SpaceModel.fromJson)),
    );
  }

  @override
  Future<Either<Failure, SpaceModel>> createSpace(
    SpaceCreateRequestModel request,
  ) async {
    final result = await _api.createSpace(request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(SpaceModel.fromJson(_extractSingle(json))),
    );
  }

  @override
  Future<Either<Failure, SpaceModel>> getSpace(String spaceId) async {
    final result = await _api.getSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(SpaceModel.fromJson(_extractSingle(json))),
    );
  }

  @override
  Future<Either<Failure, void>> deleteSpace(String spaceId) {
    return _api.deleteSpace(spaceId);
  }

  @override
  Future<Either<Failure, void>> leaveSpace(String spaceId) async {
    final result = await _api.leaveSpace(spaceId);
    return result.fold(ifLeft: Left.new, ifRight: (_) => const Right(null));
  }

  @override
  Future<Either<Failure, SpaceModel>> expandSpace(String spaceId) async {
    final result = await _api.expandSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(SpaceModel.fromJson(_extractSingle(json))),
    );
  }

  @override
  Future<Either<Failure, List<SpaceMemberModel>>> listMembers(
    String spaceId,
  ) async {
    final result = await _api.listMembers(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        _extractItems(json)
            .map(
              (item) =>
                  SpaceMemberModel.fromJson(item, fallbackSpaceId: spaceId),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceMemberModel>> addMember(
    String spaceId,
    SpaceMemberCreateRequestModel request,
  ) async {
    final result = await _api.addMember(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceMemberModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceMemberModel>> updateMemberRole(
    String spaceId,
    String userId,
    SpaceMemberRoleUpdateRequestModel request,
  ) async {
    final result = await _api.updateMemberRole(
      spaceId,
      userId,
      request.toJson(),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceMemberModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> removeMember(String spaceId, String userId) {
    return _api.removeMember(spaceId, userId);
  }

  @override
  Future<Either<Failure, List<SpaceInviteModel>>> listInvites(
    String spaceId,
  ) async {
    final result = await _api.listInvites(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        _extractItems(json)
            .map(
              (item) =>
                  SpaceInviteModel.fromJson(item, fallbackSpaceId: spaceId),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceInviteModel>> createInvite(
    String spaceId,
    SpaceInviteCreateRequestModel request,
  ) async {
    final result = await _api.createInvite(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceInviteModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceInviteModel>> revokeInvite(
    String spaceId,
    String inviteId,
  ) async {
    final result = await _api.revokeInvite(spaceId, inviteId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceInviteModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceModel>> acceptInviteToken(String token) async {
    final result = await _api.acceptInviteToken(token);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(SpaceModel.fromJson(_extractSingle(json))),
    );
  }

  @override
  Future<Either<Failure, List<SpaceListModel>>> listLists(
    String spaceId,
  ) async {
    final result = await _api.listLists(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        _extractItems(json)
            .map(
              (item) => SpaceListModel.fromJson(item, fallbackSpaceId: spaceId),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceListModel>> createList(
    String spaceId,
    SpaceTaskListCreateRequestModel request,
  ) async {
    final result = await _api.createList(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceListModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, List<SpaceListModel>>> reorderLists(
    String spaceId,
    SpaceTaskListReorderRequestModel request,
  ) async {
    final result = await _api.reorderLists(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        _extractItems(json)
            .map(
              (item) => SpaceListModel.fromJson(item, fallbackSpaceId: spaceId),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceListModel>> updateList(
    String spaceId,
    String listId,
    SpaceTaskListUpdateRequestModel request,
  ) async {
    final result = await _api.updateList(spaceId, listId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceListModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteList(String spaceId, String listId) {
    return _api.deleteList(spaceId, listId);
  }

  @override
  Future<Either<Failure, PagedResultModel<SpaceTaskModel>>> listTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  }) async {
    final result = await _api.listTasks(
      spaceId,
      listId: listId,
      cursor: cursor,
      limit: limit,
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        PagedResultModel.fromJson(
          json,
          (item) => SpaceTaskModel.fromJson(item, fallbackSpaceId: spaceId),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> createTask(
    String spaceId,
    SpaceTaskCreateRequestModel request,
  ) async {
    final result = await _api.createTask(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> getTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.getTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> updateTask(
    String spaceId,
    String taskId,
    SpaceTaskUpdateRequestModel request,
  ) async {
    final result = await _api.updateTask(spaceId, taskId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTask(String spaceId, String taskId) {
    return _api.deleteTask(spaceId, taskId);
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> claimTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.claimTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> unclaimTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.unclaimTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> assignTask(
    String spaceId,
    String taskId,
    SpaceTaskAssignRequestModel request,
  ) async {
    final result = await _api.assignTask(spaceId, taskId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> completeTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.completeTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskModel>> uncompleteTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.uncompleteTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceTaskModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, List<SpaceSubTaskModel>>> listSubtasks(
    String spaceId,
    String taskId,
  ) async {
    final result = await _api.listSubtasks(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        _extractItems(json)
            .map(
              (item) => SpaceSubTaskModel.fromJson(
                item,
                fallbackSpaceId: spaceId,
                fallbackTaskId: taskId,
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceSubTaskModel>> createSubtask(
    String spaceId,
    String taskId,
    SpaceSubTaskCreateRequestModel request,
  ) async {
    final result = await _api.createSubtask(spaceId, taskId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceSubTaskModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
          fallbackTaskId: taskId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceSubTaskModel>> updateSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
    SpaceSubTaskUpdateRequestModel request,
  ) async {
    final result = await _api.updateSubtask(
      spaceId,
      taskId,
      subtaskId,
      request.toJson(),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceSubTaskModel.fromJson(
          _extractSingle(json),
          fallbackSpaceId: spaceId,
          fallbackTaskId: taskId,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteSubtask(
    String spaceId,
    String taskId,
    String subtaskId,
  ) {
    return _api.deleteSubtask(spaceId, taskId, subtaskId);
  }

  @override
  Future<Either<Failure, PagedResultModel<SpaceNoteModel>>> listNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  }) async {
    final result = await _api.listNotes(spaceId, cursor: cursor, limit: limit);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        PagedResultModel.fromJson(
          json,
          (item) => SpaceNoteModel.fromJson(item, fallbackSpaceId: spaceId),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceNoteModel>> createNote(
    String spaceId,
    SpaceNoteCreateRequestModel request,
  ) async {
    final result = await _api.createNote(spaceId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceNoteModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceNoteModel>> getNote(
    String spaceId,
    String noteId,
  ) async {
    final result = await _api.getNote(spaceId, noteId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceNoteModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, SpaceNoteModel>> updateNote(
    String spaceId,
    String noteId,
    SpaceNoteUpdateRequestModel request,
  ) async {
    final result = await _api.updateNote(spaceId, noteId, request.toJson());
    return result.fold(
      ifLeft: Left.new,
      ifRight: (json) => Right(
        SpaceNoteModel.fromJson(_extractSingle(json), fallbackSpaceId: spaceId),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteNote(String spaceId, String noteId) {
    return _api.deleteNote(spaceId, noteId);
  }
}
