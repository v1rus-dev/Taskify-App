import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/database/app_database.dart' as db;

abstract class SubTaskLocalDataSource {
  Future<Either<Failure, List<db.SubtasksTableData>>> insertSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  );
  Future<Either<Failure, List<db.SubtasksTableData>>> updateSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  );
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds);
  Future<Either<Failure, void>> removeSubTask(int subTaskId);
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByTaskId(
    int taskId,
  );
}

class SubTaskLocalDataSourceImpl implements SubTaskLocalDataSource {
  SubTaskLocalDataSourceImpl(this._database);

  final db.AppDatabase _database;

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> insertSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  ) async {
    try {
      final ids = <int>[];
      await _database.transaction(() async {
        for (final subTask in subTasks) {
          final id = await _database.into(_database.subtasksTable).insert(
                subTask,
              );
          ids.add(id);
        }
      });

      if (ids.isEmpty) {
        return const Right([]);
      }

      final created = await (_database.select(_database.subtasksTable)
            ..where((t) => t.id.isIn(ids)))
          .get();
      return Right(created);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> updateSubTasks(
    List<db.SubtasksTableCompanion> subTasks,
  ) async {
    try {
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

      final updated = await (_database.select(_database.subtasksTable)
            ..where((t) => t.id.isIn(ids)))
          .get();
      return Right(updated);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds) async {
    try {
      if (subTaskIds.isEmpty) {
        return const Right(null);
      }
      await (_database.delete(_database.subtasksTable)
            ..where((t) => t.id.isIn(subTaskIds)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeSubTask(int subTaskId) async {
    try {
      await (_database.delete(_database.subtasksTable)
            ..where((t) => t.id.equals(subTaskId)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.SubtasksTableData>>> getSubTasksByTaskId(
    int taskId,
  ) async {
    try {
      final subtasks = await (_database.select(_database.subtasksTable)
            ..where((t) => t.taskId.equals(taskId)))
          .get();
      return Right(subtasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
