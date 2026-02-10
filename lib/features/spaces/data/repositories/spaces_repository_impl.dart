import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/features/spaces/data/datasources/spaces_local_datasource.dart';
import 'package:taskify/features/spaces/data/datasources/spaces_network_datasource.dart';
import 'package:taskify/features/spaces/data/mappers/spaces_mapper.dart';
import 'package:taskify/features/spaces/data/models/spaces_models.dart';
import 'package:taskify/features/spaces/domain/models/paged_result.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/models/space_invite.dart';
import 'package:taskify/features/spaces/domain/models/space_list.dart';
import 'package:taskify/features/spaces/domain/models/space_member.dart';
import 'package:taskify/features/spaces/domain/models/space_note.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';
import 'package:taskify/features/spaces/domain/models/space_subtask.dart';
import 'package:taskify/features/spaces/domain/models/space_task.dart';
import 'package:taskify/features/spaces/domain/repositories/space_repository.dart';

class SpacesRepositoryImpl implements SpaceRepository {
  SpacesRepositoryImpl({
    required SpacesNetworkDataSource networkDataSource,
    required SpacesLocalDataSource localDataSource,
  }) : _network = networkDataSource,
       _local = localDataSource;

  final SpacesNetworkDataSource _network;
  final SpacesLocalDataSource _local;

  @override
  Stream<List<SpaceEntity>> observeSpaces() {
    return _local.observeSpaces().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  @override
  Future<Either<Failure, PagedResultEntity<SpaceEntity>>> refreshSpaces({
    String? cursor,
    int? limit,
  }) async {
    final result = await _network.listSpaces(cursor: cursor, limit: limit);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (paged) async {
        await _local.replaceSpaces(paged.items);
        return Right(paged.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceEntity>> createSpace({
    required String name,
    String? description,
    bool isLightweight = false,
  }) async {
    final result = await _network.createSpace(
      SpaceCreateRequestModel(
        name: name,
        description: description,
        isLightweight: isLightweight,
      ),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSpace(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceEntity>> getSpace(String spaceId) async {
    final result = await _network.getSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSpace(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteSpace(String spaceId) async {
    final result = await _network.deleteSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteSpaceById(spaceId),
    );
  }

  @override
  Future<Either<Failure, void>> leaveSpace(String spaceId) async {
    final result = await _network.leaveSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteSpaceById(spaceId),
    );
  }

  @override
  Future<Either<Failure, SpaceEntity>> expandSpace(String spaceId) async {
    final result = await _network.expandSpace(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSpace(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Stream<List<SpaceMemberEntity>> observeMembers(String spaceId) {
    return _local
        .observeMembers(spaceId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, List<SpaceMemberEntity>>> refreshMembers(
    String spaceId,
  ) async {
    final result = await _network.listMembers(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (items) async {
        await _local.replaceMembers(spaceId, items);
        return Right(items.map((item) => item.toDomain()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceMemberEntity>> addMember({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  }) async {
    final result = await _network.addMember(
      spaceId,
      SpaceMemberCreateRequestModel(userId: userId, role: role),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertMember(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceMemberEntity>> updateMemberRole({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  }) async {
    final result = await _network.updateMemberRole(
      spaceId,
      userId,
      SpaceMemberRoleUpdateRequestModel(role: role),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertMember(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeMember(
    String spaceId,
    String userId,
  ) async {
    final result = await _network.removeMember(spaceId, userId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteMember(spaceId, userId),
    );
  }

  @override
  Stream<List<SpaceInviteEntity>> observeInvites(String spaceId) {
    return _local
        .observeInvites(spaceId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, List<SpaceInviteEntity>>> refreshInvites(
    String spaceId,
  ) async {
    final result = await _network.listInvites(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (items) async {
        await _local.replaceInvites(spaceId, items);
        return Right(items.map((item) => item.toDomain()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceInviteEntity>> createInvite({
    required String spaceId,
    required SpaceRole role,
    DateTime? expiresAt,
  }) async {
    final result = await _network.createInvite(
      spaceId,
      SpaceInviteCreateRequestModel(role: role, expiresAt: expiresAt),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertInvite(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceInviteEntity>> revokeInvite({
    required String spaceId,
    required String inviteId,
  }) async {
    final result = await _network.revokeInvite(spaceId, inviteId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertInvite(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceEntity>> acceptInviteToken(String token) async {
    final result = await _network.acceptInviteToken(token);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSpace(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Stream<List<SpaceListEntity>> observeLists(String spaceId) {
    return _local
        .observeLists(spaceId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, List<SpaceListEntity>>> refreshLists(
    String spaceId,
  ) async {
    final result = await _network.listLists(spaceId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (items) async {
        await _local.replaceLists(spaceId, items);
        return Right(items.map((item) => item.toDomain()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceListEntity>> createList({
    required String spaceId,
    required String title,
  }) async {
    final result = await _network.createList(
      spaceId,
      SpaceTaskListCreateRequestModel(title: title),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertList(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, List<SpaceListEntity>>> reorderLists({
    required String spaceId,
    required List<String> orderedIds,
  }) async {
    final result = await _network.reorderLists(
      spaceId,
      SpaceTaskListReorderRequestModel(orderedIds: orderedIds),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (items) async {
        await _local.replaceLists(spaceId, items);
        return Right(items.map((item) => item.toDomain()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceListEntity>> updateList({
    required String spaceId,
    required String listId,
    required String title,
  }) async {
    final result = await _network.updateList(
      spaceId,
      listId,
      SpaceTaskListUpdateRequestModel(title: title),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertList(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteList(
    String spaceId,
    String listId,
  ) async {
    final result = await _network.deleteList(spaceId, listId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteList(listId),
    );
  }

  @override
  Stream<List<SpaceTaskEntity>> observeTasks(String spaceId) {
    return _local
        .observeTasks(spaceId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, PagedResultEntity<SpaceTaskEntity>>> refreshTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  }) async {
    final result = await _network.listTasks(
      spaceId,
      listId: listId,
      cursor: cursor,
      limit: limit,
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (paged) async {
        await _local.replaceTasks(spaceId, paged.items);
        return Right(
          PagedResultEntity(
            items: paged.items.map((item) => item.toDomain()).toList(),
            nextCursor: paged.nextCursor,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> createTask({
    required String spaceId,
    required String title,
    String? listId,
    String? description,
  }) async {
    final result = await _network.createTask(
      spaceId,
      SpaceTaskCreateRequestModel(
        title: title,
        listId: listId,
        description: description,
      ),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> getTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.getTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> updateTask({
    required String spaceId,
    required String taskId,
    String? title,
    String? listId,
    String? description,
  }) async {
    final result = await _network.updateTask(
      spaceId,
      taskId,
      SpaceTaskUpdateRequestModel(
        title: title,
        listId: listId,
        description: description,
      ),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.deleteTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteTask(taskId),
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> claimTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.claimTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> unclaimTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.unclaimTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> assignTask({
    required String spaceId,
    required String taskId,
    required String userId,
  }) async {
    final result = await _network.assignTask(
      spaceId,
      taskId,
      SpaceTaskAssignRequestModel(userId: userId),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> completeTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.completeTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceTaskEntity>> uncompleteTask(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.uncompleteTask(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Stream<List<SpaceSubTaskEntity>> observeSubTasks(String taskId) {
    return _local
        .observeSubTasks(taskId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, List<SpaceSubTaskEntity>>> refreshSubTasks(
    String spaceId,
    String taskId,
  ) async {
    final result = await _network.listSubtasks(spaceId, taskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (items) async {
        await _local.replaceSubTasks(taskId, items);
        return Right(items.map((item) => item.toDomain()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceSubTaskEntity>> createSubTask({
    required String spaceId,
    required String taskId,
    required String title,
  }) async {
    final result = await _network.createSubtask(
      spaceId,
      taskId,
      SpaceSubTaskCreateRequestModel(title: title),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSubTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceSubTaskEntity>> updateSubTask({
    required String spaceId,
    required String taskId,
    required String subTaskId,
    String? title,
    bool? isCompleted,
  }) async {
    final result = await _network.updateSubtask(
      spaceId,
      taskId,
      subTaskId,
      SpaceSubTaskUpdateRequestModel(title: title, isCompleted: isCompleted),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertSubTask(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteSubTask(
    String spaceId,
    String taskId,
    String subTaskId,
  ) async {
    final result = await _network.deleteSubtask(spaceId, taskId, subTaskId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteSubTask(subTaskId),
    );
  }

  @override
  Stream<List<SpaceNoteEntity>> observeNotes(String spaceId) {
    return _local
        .observeNotes(spaceId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Either<Failure, PagedResultEntity<SpaceNoteEntity>>> refreshNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  }) async {
    final result = await _network.listNotes(
      spaceId,
      cursor: cursor,
      limit: limit,
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (paged) async {
        await _local.replaceNotes(spaceId, paged.items);
        return Right(
          PagedResultEntity(
            items: paged.items.map((item) => item.toDomain()).toList(),
            nextCursor: paged.nextCursor,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, SpaceNoteEntity>> createNote({
    required String spaceId,
    required String title,
    String? body,
  }) async {
    final result = await _network.createNote(
      spaceId,
      SpaceNoteCreateRequestModel(title: title, body: body),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertNote(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceNoteEntity>> getNote(
    String spaceId,
    String noteId,
  ) async {
    final result = await _network.getNote(spaceId, noteId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertNote(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, SpaceNoteEntity>> updateNote({
    required String spaceId,
    required String noteId,
    String? title,
    String? body,
  }) async {
    final result = await _network.updateNote(
      spaceId,
      noteId,
      SpaceNoteUpdateRequestModel(title: title, body: body),
    );
    return result.fold(
      ifLeft: Left.new,
      ifRight: (model) async {
        await _local.upsertNote(model);
        return Right(model.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteNote(
    String spaceId,
    String noteId,
  ) async {
    final result = await _network.deleteNote(spaceId, noteId);
    return result.fold(
      ifLeft: Left.new,
      ifRight: (_) => _local.deleteNote(noteId),
    );
  }
}

extension _SpaceRowMapper on db.SpacesTableData {
  SpaceEntity toDomain() {
    return SpaceEntity(
      id: id,
      name: name,
      description: description,
      role: SpaceRole.fromValue(role),
      isLightweight: isLightweight,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension _SpaceMemberRowMapper on db.SpaceMembersTableData {
  SpaceMemberEntity toDomain() {
    return SpaceMemberEntity(
      spaceId: spaceId,
      userId: userId,
      name: name,
      avatarUrl: avatarUrl,
      role: SpaceRole.fromValue(role),
      joinedAt: joinedAt,
    );
  }
}

extension _SpaceInviteRowMapper on db.SpaceInvitesTableData {
  SpaceInviteEntity toDomain() {
    return SpaceInviteEntity(
      id: id,
      spaceId: spaceId,
      token: token,
      role: SpaceRole.fromValue(role),
      isRevoked: isRevoked,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }
}

extension _SpaceListRowMapper on db.SpaceListsTableData {
  SpaceListEntity toDomain() {
    return SpaceListEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      order: order,
      updatedAt: updatedAt,
    );
  }
}

extension _SpaceTaskRowMapper on db.SpaceTasksTableData {
  SpaceTaskEntity toDomain() {
    return SpaceTaskEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      listId: listId,
      description: description,
      assigneeId: assigneeId,
      claimedById: claimedById,
      isCompleted: isCompleted,
      completedAt: completedAt,
      updatedAt: updatedAt,
    );
  }
}

extension _SpaceSubTaskRowMapper on db.SpaceSubtasksTableData {
  SpaceSubTaskEntity toDomain() {
    return SpaceSubTaskEntity(
      id: id,
      spaceId: spaceId,
      taskId: taskId,
      title: title,
      isCompleted: isCompleted,
      updatedAt: updatedAt,
    );
  }
}

extension _SpaceNoteRowMapper on db.SpaceNotesTableData {
  SpaceNoteEntity toDomain() {
    return SpaceNoteEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      body: body,
      updatedAt: updatedAt,
    );
  }
}
