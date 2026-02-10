import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/features/spaces/data/models/spaces_models.dart';

abstract class SpacesLocalDataSource {
  Stream<List<db.SpacesTableData>> observeSpaces();
  Future<Either<Failure, void>> replaceSpaces(List<SpaceModel> spaces);
  Future<Either<Failure, void>> upsertSpace(SpaceModel space);
  Future<Either<Failure, void>> deleteSpaceById(String spaceId);

  Stream<List<db.SpaceMembersTableData>> observeMembers(String spaceId);
  Future<Either<Failure, void>> replaceMembers(
    String spaceId,
    List<SpaceMemberModel> members,
  );
  Future<Either<Failure, void>> upsertMember(SpaceMemberModel member);
  Future<Either<Failure, void>> deleteMember(String spaceId, String userId);

  Stream<List<db.SpaceInvitesTableData>> observeInvites(String spaceId);
  Future<Either<Failure, void>> replaceInvites(
    String spaceId,
    List<SpaceInviteModel> invites,
  );
  Future<Either<Failure, void>> upsertInvite(SpaceInviteModel invite);

  Stream<List<db.SpaceListsTableData>> observeLists(String spaceId);
  Future<Either<Failure, void>> replaceLists(
    String spaceId,
    List<SpaceListModel> lists,
  );
  Future<Either<Failure, void>> upsertList(SpaceListModel list);
  Future<Either<Failure, void>> deleteList(String listId);

  Stream<List<db.SpaceTasksTableData>> observeTasks(String spaceId);
  Future<Either<Failure, void>> replaceTasks(
    String spaceId,
    List<SpaceTaskModel> tasks,
  );
  Future<Either<Failure, void>> upsertTask(SpaceTaskModel task);
  Future<Either<Failure, void>> deleteTask(String taskId);

  Stream<List<db.SpaceSubtasksTableData>> observeSubTasks(String taskId);
  Future<Either<Failure, void>> replaceSubTasks(
    String taskId,
    List<SpaceSubTaskModel> subTasks,
  );
  Future<Either<Failure, void>> upsertSubTask(SpaceSubTaskModel subTask);
  Future<Either<Failure, void>> deleteSubTask(String subTaskId);

  Stream<List<db.SpaceNotesTableData>> observeNotes(String spaceId);
  Future<Either<Failure, void>> replaceNotes(
    String spaceId,
    List<SpaceNoteModel> notes,
  );
  Future<Either<Failure, void>> upsertNote(SpaceNoteModel note);
  Future<Either<Failure, void>> deleteNote(String noteId);
}

class SpacesLocalDataSourceImpl implements SpacesLocalDataSource {
  SpacesLocalDataSourceImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<db.SpacesTableData>> observeSpaces() {
    return (_database.select(
      _database.spacesTable,
    )..orderBy([(space) => OrderingTerm(expression: space.name)])).watch();
  }

  @override
  Future<Either<Failure, void>> replaceSpaces(List<SpaceModel> spaces) async {
    try {
      await _database.batch((batch) {
        batch.deleteAll(_database.spacesTable);
        if (spaces.isNotEmpty) {
          batch.insertAll(
            _database.spacesTable,
            spaces.map(_spaceCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceSpaces error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertSpace(SpaceModel space) async {
    try {
      await _database
          .into(_database.spacesTable)
          .insertOnConflictUpdate(_spaceCompanion(space));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertSpace error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSpaceById(String spaceId) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(
          _database.spacesTable,
        )..where((row) => row.id.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceMembersTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceInvitesTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceListsTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceTasksTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceSubtasksTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
        await (_database.delete(
          _database.spaceNotesTable,
        )..where((row) => row.spaceId.equals(spaceId))).go();
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteSpaceById error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceMembersTableData>> observeMembers(String spaceId) {
    final query = _database.select(_database.spaceMembersTable)
      ..where((row) => row.spaceId.equals(spaceId));
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceMembers(
    String spaceId,
    List<SpaceMemberModel> members,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceMembersTable,
          (row) => row.spaceId.equals(spaceId),
        );
        if (members.isNotEmpty) {
          batch.insertAll(
            _database.spaceMembersTable,
            members.map(_memberCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceMembers error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertMember(SpaceMemberModel member) async {
    try {
      await (_database.delete(_database.spaceMembersTable)..where(
            (row) =>
                row.spaceId.equals(member.spaceId) &
                row.userId.equals(member.userId),
          ))
          .go();
      await _database
          .into(_database.spaceMembersTable)
          .insert(_memberCompanion(member));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertMember error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMember(
    String spaceId,
    String userId,
  ) async {
    try {
      await (_database.delete(_database.spaceMembersTable)..where(
            (row) => row.spaceId.equals(spaceId) & row.userId.equals(userId),
          ))
          .go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteMember error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceInvitesTableData>> observeInvites(String spaceId) {
    final query = _database.select(_database.spaceInvitesTable)
      ..where((row) => row.spaceId.equals(spaceId));
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceInvites(
    String spaceId,
    List<SpaceInviteModel> invites,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceInvitesTable,
          (row) => row.spaceId.equals(spaceId),
        );
        if (invites.isNotEmpty) {
          batch.insertAll(
            _database.spaceInvitesTable,
            invites.map(_inviteCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceInvites error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertInvite(SpaceInviteModel invite) async {
    try {
      await _database
          .into(_database.spaceInvitesTable)
          .insertOnConflictUpdate(_inviteCompanion(invite));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertInvite error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceListsTableData>> observeLists(String spaceId) {
    final query = _database.select(_database.spaceListsTable)
      ..where((row) => row.spaceId.equals(spaceId))
      ..orderBy([(row) => OrderingTerm(expression: row.order)]);
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceLists(
    String spaceId,
    List<SpaceListModel> lists,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceListsTable,
          (row) => row.spaceId.equals(spaceId),
        );
        if (lists.isNotEmpty) {
          batch.insertAll(
            _database.spaceListsTable,
            lists.map(_listCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceLists error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertList(SpaceListModel list) async {
    try {
      await _database
          .into(_database.spaceListsTable)
          .insertOnConflictUpdate(_listCompanion(list));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertList error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteList(String listId) async {
    try {
      await (_database.delete(
        _database.spaceListsTable,
      )..where((row) => row.id.equals(listId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteList error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceTasksTableData>> observeTasks(String spaceId) {
    final query = _database.select(_database.spaceTasksTable)
      ..where((row) => row.spaceId.equals(spaceId));
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceTasks(
    String spaceId,
    List<SpaceTaskModel> tasks,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceTasksTable,
          (row) => row.spaceId.equals(spaceId),
        );
        if (tasks.isNotEmpty) {
          batch.insertAll(
            _database.spaceTasksTable,
            tasks.map(_taskCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertTask(SpaceTaskModel task) async {
    try {
      await _database
          .into(_database.spaceTasksTable)
          .insertOnConflictUpdate(_taskCompanion(task));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await (_database.delete(
        _database.spaceTasksTable,
      )..where((row) => row.id.equals(taskId))).go();
      await (_database.delete(
        _database.spaceSubtasksTable,
      )..where((row) => row.taskId.equals(taskId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceSubtasksTableData>> observeSubTasks(String taskId) {
    final query = _database.select(_database.spaceSubtasksTable)
      ..where((row) => row.taskId.equals(taskId));
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceSubTasks(
    String taskId,
    List<SpaceSubTaskModel> subTasks,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceSubtasksTable,
          (row) => row.taskId.equals(taskId),
        );
        if (subTasks.isNotEmpty) {
          batch.insertAll(
            _database.spaceSubtasksTable,
            subTasks.map(_subTaskCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceSubTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertSubTask(SpaceSubTaskModel subTask) async {
    try {
      await _database
          .into(_database.spaceSubtasksTable)
          .insertOnConflictUpdate(_subTaskCompanion(subTask));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertSubTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubTask(String subTaskId) async {
    try {
      await (_database.delete(
        _database.spaceSubtasksTable,
      )..where((row) => row.id.equals(subTaskId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteSubTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SpaceNotesTableData>> observeNotes(String spaceId) {
    final query = _database.select(_database.spaceNotesTable)
      ..where((row) => row.spaceId.equals(spaceId));
    return query.watch();
  }

  @override
  Future<Either<Failure, void>> replaceNotes(
    String spaceId,
    List<SpaceNoteModel> notes,
  ) async {
    try {
      await _database.batch((batch) {
        batch.deleteWhere(
          _database.spaceNotesTable,
          (row) => row.spaceId.equals(spaceId),
        );
        if (notes.isNotEmpty) {
          batch.insertAll(
            _database.spaceNotesTable,
            notes.map(_noteCompanion).toList(),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces replaceNotes error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> upsertNote(SpaceNoteModel note) async {
    try {
      await _database
          .into(_database.spaceNotesTable)
          .insertOnConflictUpdate(_noteCompanion(note));
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces upsertNote error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) async {
    try {
      await (_database.delete(
        _database.spaceNotesTable,
      )..where((row) => row.id.equals(noteId))).go();
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('spaces deleteNote error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  db.SpacesTableCompanion _spaceCompanion(SpaceModel space) {
    return db.SpacesTableCompanion(
      id: Value(space.id),
      name: Value(space.name),
      description: Value(space.description),
      role: Value(space.role.value),
      isLightweight: Value(space.isLightweight),
      createdAt: Value(space.createdAt),
      updatedAt: Value(space.updatedAt),
    );
  }

  db.SpaceMembersTableCompanion _memberCompanion(SpaceMemberModel member) {
    return db.SpaceMembersTableCompanion.insert(
      spaceId: member.spaceId,
      userId: member.userId,
      name: Value(member.name),
      avatarUrl: Value(member.avatarUrl),
      role: Value(member.role.value),
      joinedAt: Value(member.joinedAt),
    );
  }

  db.SpaceInvitesTableCompanion _inviteCompanion(SpaceInviteModel invite) {
    return db.SpaceInvitesTableCompanion(
      id: Value(invite.id),
      spaceId: Value(invite.spaceId),
      token: Value(invite.token),
      role: Value(invite.role.value),
      isRevoked: Value(invite.isRevoked),
      expiresAt: Value(invite.expiresAt),
      createdAt: Value(invite.createdAt),
    );
  }

  db.SpaceListsTableCompanion _listCompanion(SpaceListModel list) {
    return db.SpaceListsTableCompanion(
      id: Value(list.id),
      spaceId: Value(list.spaceId),
      title: Value(list.title),
      order: Value(list.order),
      updatedAt: Value(list.updatedAt),
    );
  }

  db.SpaceTasksTableCompanion _taskCompanion(SpaceTaskModel task) {
    return db.SpaceTasksTableCompanion(
      id: Value(task.id),
      spaceId: Value(task.spaceId),
      listId: Value(task.listId),
      title: Value(task.title),
      description: Value(task.description),
      assigneeId: Value(task.assigneeId),
      claimedById: Value(task.claimedById),
      isCompleted: Value(task.isCompleted),
      completedAt: Value(task.completedAt),
      updatedAt: Value(task.updatedAt),
    );
  }

  db.SpaceSubtasksTableCompanion _subTaskCompanion(SpaceSubTaskModel subTask) {
    return db.SpaceSubtasksTableCompanion(
      id: Value(subTask.id),
      spaceId: Value(subTask.spaceId),
      taskId: Value(subTask.taskId),
      title: Value(subTask.title),
      isCompleted: Value(subTask.isCompleted),
      updatedAt: Value(subTask.updatedAt),
    );
  }

  db.SpaceNotesTableCompanion _noteCompanion(SpaceNoteModel note) {
    return db.SpaceNotesTableCompanion(
      id: Value(note.id),
      spaceId: Value(note.spaceId),
      title: Value(note.title),
      body: Value(note.body),
      updatedAt: Value(note.updatedAt),
    );
  }
}
