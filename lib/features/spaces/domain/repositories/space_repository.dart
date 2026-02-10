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

abstract class SpaceRepository {
  Stream<List<SpaceEntity>> observeSpaces();
  Future<Either<Failure, PagedResultEntity<SpaceEntity>>> refreshSpaces({
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceEntity>> createSpace({
    required String name,
    String? description,
    bool isLightweight,
  });
  Future<Either<Failure, SpaceEntity>> getSpace(String spaceId);
  Future<Either<Failure, void>> deleteSpace(String spaceId);
  Future<Either<Failure, void>> leaveSpace(String spaceId);
  Future<Either<Failure, SpaceEntity>> expandSpace(String spaceId);

  Stream<List<SpaceMemberEntity>> observeMembers(String spaceId);
  Future<Either<Failure, List<SpaceMemberEntity>>> refreshMembers(
    String spaceId,
  );
  Future<Either<Failure, SpaceMemberEntity>> addMember({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  });
  Future<Either<Failure, SpaceMemberEntity>> updateMemberRole({
    required String spaceId,
    required String userId,
    required SpaceRole role,
  });
  Future<Either<Failure, void>> removeMember(String spaceId, String userId);

  Stream<List<SpaceInviteEntity>> observeInvites(String spaceId);
  Future<Either<Failure, List<SpaceInviteEntity>>> refreshInvites(
    String spaceId,
  );
  Future<Either<Failure, SpaceInviteEntity>> createInvite({
    required String spaceId,
    required SpaceRole role,
    DateTime? expiresAt,
  });
  Future<Either<Failure, SpaceInviteEntity>> revokeInvite({
    required String spaceId,
    required String inviteId,
  });
  Future<Either<Failure, SpaceEntity>> acceptInviteToken(String token);

  Stream<List<SpaceListEntity>> observeLists(String spaceId);
  Future<Either<Failure, List<SpaceListEntity>>> refreshLists(String spaceId);
  Future<Either<Failure, SpaceListEntity>> createList({
    required String spaceId,
    required String title,
  });
  Future<Either<Failure, List<SpaceListEntity>>> reorderLists({
    required String spaceId,
    required List<String> orderedIds,
  });
  Future<Either<Failure, SpaceListEntity>> updateList({
    required String spaceId,
    required String listId,
    required String title,
  });
  Future<Either<Failure, void>> deleteList(String spaceId, String listId);

  Stream<List<SpaceTaskEntity>> observeTasks(String spaceId);
  Future<Either<Failure, PagedResultEntity<SpaceTaskEntity>>> refreshTasks(
    String spaceId, {
    String? listId,
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceTaskEntity>> createTask({
    required String spaceId,
    required String title,
    String? listId,
    String? description,
  });
  Future<Either<Failure, SpaceTaskEntity>> getTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskEntity>> updateTask({
    required String spaceId,
    required String taskId,
    String? title,
    String? listId,
    String? description,
  });
  Future<Either<Failure, void>> deleteTask(String spaceId, String taskId);
  Future<Either<Failure, SpaceTaskEntity>> claimTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskEntity>> unclaimTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskEntity>> assignTask({
    required String spaceId,
    required String taskId,
    required String userId,
  });
  Future<Either<Failure, SpaceTaskEntity>> completeTask(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceTaskEntity>> uncompleteTask(
    String spaceId,
    String taskId,
  );

  Stream<List<SpaceSubTaskEntity>> observeSubTasks(String taskId);
  Future<Either<Failure, List<SpaceSubTaskEntity>>> refreshSubTasks(
    String spaceId,
    String taskId,
  );
  Future<Either<Failure, SpaceSubTaskEntity>> createSubTask({
    required String spaceId,
    required String taskId,
    required String title,
  });
  Future<Either<Failure, SpaceSubTaskEntity>> updateSubTask({
    required String spaceId,
    required String taskId,
    required String subTaskId,
    String? title,
    bool? isCompleted,
  });
  Future<Either<Failure, void>> deleteSubTask(
    String spaceId,
    String taskId,
    String subTaskId,
  );

  Stream<List<SpaceNoteEntity>> observeNotes(String spaceId);
  Future<Either<Failure, PagedResultEntity<SpaceNoteEntity>>> refreshNotes(
    String spaceId, {
    String? cursor,
    int? limit,
  });
  Future<Either<Failure, SpaceNoteEntity>> createNote({
    required String spaceId,
    required String title,
    String? body,
  });
  Future<Either<Failure, SpaceNoteEntity>> getNote(
    String spaceId,
    String noteId,
  );
  Future<Either<Failure, SpaceNoteEntity>> updateNote({
    required String spaceId,
    required String noteId,
    String? title,
    String? body,
  });
  Future<Either<Failure, void>> deleteNote(String spaceId, String noteId);
}
