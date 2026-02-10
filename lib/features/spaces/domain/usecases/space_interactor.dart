import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
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

class SpaceInteractor {
  SpaceInteractor(this._repository);

  final SpaceRepository _repository;

  Stream<List<SpaceEntity>> observeSpaces() => _repository.observeSpaces();

  Future<Either<Failure, PagedResultEntity<SpaceEntity>>> refreshSpaces({
    String? cursor,
    int? limit,
  }) {
    return _repository.refreshSpaces(cursor: cursor, limit: limit);
  }

  Future<Either<Failure, SpaceEntity>> createSpace({
    required String name,
    String? description,
    bool isLightweight = false,
  }) {
    return _repository.createSpace(
      name: name,
      description: description,
      isLightweight: isLightweight,
    );
  }

  Future<Either<Failure, void>> deleteSpace(String spaceId) {
    return _repository.deleteSpace(spaceId);
  }

  Future<Either<Failure, void>> leaveSpace(String spaceId) {
    return _repository.leaveSpace(spaceId);
  }

  Future<Either<Failure, SpaceEntity>> expandSpace(String spaceId) {
    return _repository.expandSpace(spaceId);
  }

  Stream<List<SpaceMemberEntity>> observeMembers(String spaceId) {
    return _repository.observeMembers(spaceId);
  }

  Future<Either<Failure, List<SpaceMemberEntity>>> refreshMembers(
    String spaceId,
  ) {
    return _repository.refreshMembers(spaceId);
  }

  Future<Either<Failure, SpaceMemberEntity>> addMember({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  }) {
    return _repository.addMember(spaceId: spaceId, userId: userId, role: role);
  }

  Future<Either<Failure, SpaceMemberEntity>> updateMemberRole({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  }) {
    return _repository.updateMemberRole(
      spaceId: spaceId,
      userId: userId,
      role: role,
    );
  }

  Future<Either<Failure, void>> removeMember(String spaceId, String userId) {
    return _repository.removeMember(spaceId, userId);
  }

  Stream<List<SpaceInviteEntity>> observeInvites(String spaceId) {
    return _repository.observeInvites(spaceId);
  }

  Future<Either<Failure, List<SpaceInviteEntity>>> refreshInvites(
    String spaceId,
  ) {
    return _repository.refreshInvites(spaceId);
  }

  Future<Either<Failure, SpaceInviteEntity>> createInvite({
    required String spaceId,
    required SpaceRole role,
    DateTime? expiresAt,
  }) {
    return _repository.createInvite(
      spaceId: spaceId,
      role: role,
      expiresAt: expiresAt,
    );
  }

  Future<Either<Failure, SpaceInviteEntity>> revokeInvite({
    required String spaceId,
    required String inviteId,
  }) {
    return _repository.revokeInvite(spaceId: spaceId, inviteId: inviteId);
  }

  Future<Either<Failure, SpaceEntity>> acceptInviteToken(String token) {
    return _repository.acceptInviteToken(token);
  }

  Stream<List<SpaceListEntity>> observeLists(String spaceId) {
    return _repository.observeLists(spaceId);
  }

  Future<Either<Failure, List<SpaceListEntity>>> refreshLists(String spaceId) {
    return _repository.refreshLists(spaceId);
  }

  Future<Either<Failure, SpaceListEntity>> createList({
    required String spaceId,
    required String title,
  }) {
    return _repository.createList(spaceId: spaceId, title: title);
  }

  Future<Either<Failure, List<SpaceListEntity>>> reorderLists({
    required String spaceId,
    required List<String> orderedIds,
  }) {
    return _repository.reorderLists(spaceId: spaceId, orderedIds: orderedIds);
  }

  Future<Either<Failure, SpaceListEntity>> updateList({
    required String spaceId,
    required String listId,
    required String title,
  }) {
    return _repository.updateList(
      spaceId: spaceId,
      listId: listId,
      title: title,
    );
  }

  Future<Either<Failure, void>> deleteList(String spaceId, String listId) {
    return _repository.deleteList(spaceId, listId);
  }

  Stream<List<SpaceTaskEntity>> observeTasks(String spaceId) {
    return _repository.observeTasks(spaceId);
  }

  Future<Either<Failure, PagedResultEntity<SpaceTaskEntity>>> refreshTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  }) {
    return _repository.refreshTasks(
      spaceId,
      listId: listId,
      cursor: cursor,
      limit: limit,
    );
  }

  Future<Either<Failure, SpaceTaskEntity>> createTask({
    required String spaceId,
    required String title,
    String? listId,
    String? description,
  }) {
    return _repository.createTask(
      spaceId: spaceId,
      title: title,
      listId: listId,
      description: description,
    );
  }

  Future<Either<Failure, SpaceTaskEntity>> updateTask({
    required String spaceId,
    required String taskId,
    String? title,
    String? listId,
    String? description,
  }) {
    return _repository.updateTask(
      spaceId: spaceId,
      taskId: taskId,
      title: title,
      listId: listId,
      description: description,
    );
  }

  Future<Either<Failure, void>> deleteTask(String spaceId, String taskId) {
    return _repository.deleteTask(spaceId, taskId);
  }

  Future<Either<Failure, SpaceTaskEntity>> claimTask(
    String spaceId,
    String taskId,
  ) {
    return _repository.claimTask(spaceId, taskId);
  }

  Future<Either<Failure, SpaceTaskEntity>> unclaimTask(
    String spaceId,
    String taskId,
  ) {
    return _repository.unclaimTask(spaceId, taskId);
  }

  Future<Either<Failure, SpaceTaskEntity>> assignTask({
    required String spaceId,
    required String taskId,
    required String userId,
  }) {
    return _repository.assignTask(
      spaceId: spaceId,
      taskId: taskId,
      userId: userId,
    );
  }

  Future<Either<Failure, SpaceTaskEntity>> completeTask(
    String spaceId,
    String taskId,
  ) {
    return _repository.completeTask(spaceId, taskId);
  }

  Future<Either<Failure, SpaceTaskEntity>> uncompleteTask(
    String spaceId,
    String taskId,
  ) {
    return _repository.uncompleteTask(spaceId, taskId);
  }

  Stream<List<SpaceSubTaskEntity>> observeSubTasks(String taskId) {
    return _repository.observeSubTasks(taskId);
  }

  Future<Either<Failure, List<SpaceSubTaskEntity>>> refreshSubTasks(
    String spaceId,
    String taskId,
  ) {
    return _repository.refreshSubTasks(spaceId, taskId);
  }

  Future<Either<Failure, SpaceSubTaskEntity>> createSubTask({
    required String spaceId,
    required String taskId,
    required String title,
  }) {
    return _repository.createSubTask(
      spaceId: spaceId,
      taskId: taskId,
      title: title,
    );
  }

  Future<Either<Failure, SpaceSubTaskEntity>> updateSubTask({
    required String spaceId,
    required String taskId,
    required String subTaskId,
    String? title,
    bool? isCompleted,
  }) {
    return _repository.updateSubTask(
      spaceId: spaceId,
      taskId: taskId,
      subTaskId: subTaskId,
      title: title,
      isCompleted: isCompleted,
    );
  }

  Future<Either<Failure, void>> deleteSubTask(
    String spaceId,
    String taskId,
    String subTaskId,
  ) {
    return _repository.deleteSubTask(spaceId, taskId, subTaskId);
  }

  Stream<List<SpaceNoteEntity>> observeNotes(String spaceId) {
    return _repository.observeNotes(spaceId);
  }

  Future<Either<Failure, PagedResultEntity<SpaceNoteEntity>>> refreshNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  }) {
    return _repository.refreshNotes(spaceId, cursor: cursor, limit: limit);
  }

  Future<Either<Failure, SpaceNoteEntity>> createNote({
    required String spaceId,
    required String title,
    String? body,
  }) {
    return _repository.createNote(spaceId: spaceId, title: title, body: body);
  }

  Future<Either<Failure, SpaceNoteEntity>> updateNote({
    required String spaceId,
    required String noteId,
    String? title,
    String? body,
  }) {
    return _repository.updateNote(
      spaceId: spaceId,
      noteId: noteId,
      title: title,
      body: body,
    );
  }

  Future<Either<Failure, void>> deleteNote(String spaceId, String noteId) {
    return _repository.deleteNote(spaceId, noteId);
  }
}
