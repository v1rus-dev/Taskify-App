import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;

abstract class TaskLocalDataSource {
  Future<Either<Failure, List<db.TasksTableData>>> getTasks();
  Future<Either<Failure, List<db.TasksTableData>>> getTasksByDate(
    DateTime date,
  );
  Future<Either<Failure, db.TasksTableData>> getTaskById(int id);
  Future<Either<Failure, db.TasksTableData>> createTask(
    db.TasksTableCompanion task,
  );
  Future<Either<Failure, db.TasksTableData>> updateTask(db.TasksTableData task);
  Future<Either<Failure, void>> deleteTask(int id);
  Stream<List<db.TasksTableData>> observeTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final db.AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

  @override
  Future<Either<Failure, List<db.TasksTableData>>> getTasks() async {
    try {
      final driftTasks = await database.select(database.tasksTable).get();
      return Right(driftTasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.TasksTableData>>> getTasksByDate(
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final driftTasks = await (database.select(database.tasksTable)
            ..where(
              (task) => task.date.isBetweenValues(startOfDay, endOfDay),
            ))
          .get();

      return Right(driftTasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> getTaskById(int id) async {
    try {
      final driftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(id))).getSingle();
      return Right(driftTask);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> createTask(
    db.TasksTableCompanion task,
  ) async {
    try {
      final id = await database.into(database.tasksTable).insert(task);
      final createdDriftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(id))).getSingle();
      return Right(createdDriftTask);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> updateTask(
    db.TasksTableData task,
  ) async {
    try {
      final taskCompanion = task.toCompanion(true);
      await database.update(database.tasksTable).replace(taskCompanion);
      final updatedDriftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(task.id))).getSingle();
      return Right(updatedDriftTask);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await (database.delete(
        database.taskTagsTable,
      )..where((t) => t.taskId.equals(id))).go();
      await (database.delete(
        database.tasksTable,
      )..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.TasksTableData>> observeTasks() {
    return database.select(database.tasksTable).watch().map((driftTasks) {
      return driftTasks.toList();
    });
  }
}
