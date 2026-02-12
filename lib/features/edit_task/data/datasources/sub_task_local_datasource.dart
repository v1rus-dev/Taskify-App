import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/core/services/talker_service.dart';

abstract class SubTaskLocalDataSource {
  Future<Either<Failure, List<db.SubtasksTableData>>> insertSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  );
  Future<Either<Failure, List<db.SubtasksTableData>>> updateSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  );
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds);
  Future<Either<Failure, void>> removeSubTask(int subTaskId);
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByIds(
    List<int> subTaskIds,
  );
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByTaskId(
    int taskId,
  );
  Stream<List<db.SubtasksTableData>> observeSubTasks();
  Stream<List<db.SubtasksTableData>> observeSubTasksByTaskId(int taskId);
}

class SubTaskLocalDataSourceImpl implements SubTaskLocalDataSource {
  SubTaskLocalDataSourceImpl(this._database);

  final db.AppDatabase _database;

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> insertSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  ) async {
    try {
      TalkerService.instance.info(
        'syncTag insertSubTasks start: ${subTasks.length}',
      );
      final ids = <int>[];
      await _database.transaction(() async {
        for (final subTask in subTasks) {
          final id = await _database
              .into(_database.subtasksTable)
              .insert(subTask);
          ids.add(id);
        }
      });

      if (ids.isEmpty) {
        return const Right([]);
      }

      final created = await (_database.select(
        _database.subtasksTable,
      )..where((t) => t.id.isIn(ids))).get();
      TalkerService.instance.info(
        'syncTag insertSubTasks result: ${created.length}',
      );
      return Right(created);
    } catch (e) {
      TalkerService.instance.error('syncTag insertSubTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> updateSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  ) async {
    try {
      TalkerService.instance.info(
        'syncTag updateSubTasks start: ${subTasks.length}',
      );
      final ids = <int>[];
      await _database.transaction(() async {
        for (final subTask in subTasks) {
          await _database.update(_database.subtasksTable).replace(subTask);
          ids.add(subTask.id.value);
        }
      });

      if (ids.isEmpty) {
        return const Right([]);
      }

      final updated = await (_database.select(
        _database.subtasksTable,
      )..where((t) => t.id.isIn(ids))).get();
      TalkerService.instance.info(
        'syncTag updateSubTasks result: ${updated.length}',
      );
      return Right(updated);
    } catch (e) {
      TalkerService.instance.error('syncTag updateSubTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds) async {
    try {
      if (subTaskIds.isEmpty) {
        return const Right(null);
      }
      TalkerService.instance.info(
        'syncTag removeSubTasks start: ${subTaskIds.length}',
      );
      await (_database.update(
        _database.subtasksTable,
      )..where((t) => t.id.isIn(subTaskIds))).write(
        db.SubtasksTableCompanion(
          deletedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      TalkerService.instance.info('syncTag removeSubTasks done');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag removeSubTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeSubTask(int subTaskId) async {
    try {
      TalkerService.instance.info('syncTag removeSubTask start: $subTaskId');
      await (_database.update(
        _database.subtasksTable,
      )..where((t) => t.id.equals(subTaskId))).write(
        db.SubtasksTableCompanion(
          deletedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      TalkerService.instance.info('syncTag removeSubTask done: $subTaskId');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag removeSubTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByIds(
    List<int> subTaskIds,
  ) async {
    try {
      if (subTaskIds.isEmpty) {
        return const Right([]);
      }
      TalkerService.instance.info(
        'syncTag getSubTasksByIds start: ${subTaskIds.length}',
      );
      final subtasks = await (_database.select(
        _database.subtasksTable,
      )..where((t) => t.id.isIn(subTaskIds))).get();
      TalkerService.instance.info(
        'syncTag getSubTasksByIds result: ${subtasks.length}',
      );
      return Right(subtasks);
    } catch (e) {
      TalkerService.instance.error('syncTag getSubTasksByIds error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByTaskId(
    int taskId,
  ) async {
    try {
      TalkerService.instance.info('syncTag getSubTasksByTaskId start: $taskId');
      final subtasks = await (_database.select(
        _database.subtasksTable,
      )..where((t) => t.taskId.equals(taskId) & t.deletedAt.isNull())).get();
      TalkerService.instance.info(
        'syncTag getSubTasksByTaskId result: ${subtasks.length}',
      );
      return Right(subtasks);
    } catch (e) {
      TalkerService.instance.error('syncTag getSubTasksByTaskId error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.SubtasksTableData>> observeSubTasks() {
    TalkerService.instance.info('syncTag observeSubTasks start');
    return (_database.select(_database.subtasksTable)
          ..where((task) => task.deletedAt.isNull()))
        .watch()
        .map((driftSubTasks) => driftSubTasks.toList());
  }

  @override
  Stream<List<db.SubtasksTableData>> observeSubTasksByTaskId(int taskId) {
    TalkerService.instance.info(
      'syncTag observeSubTasksByTaskId start: $taskId',
    );
    return (_database.select(_database.subtasksTable)..where(
          (task) => task.taskId.equals(taskId) & task.deletedAt.isNull(),
        ))
        .watch()
        .map((driftSubTasks) => driftSubTasks.toList());
  }
}
