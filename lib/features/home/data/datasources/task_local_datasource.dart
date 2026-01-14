import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/database/app_database.dart';

abstract class TaskLocalDataSource {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, List<Task>>> getTasksByDate(DateTime date);
  Future<Either<Failure, Task>> getTaskById(int id);
  Future<Either<Failure, Task>> createTask(TasksCompanion task);
  Future<Either<Failure, Task>> updateTask(TasksCompanion task);
  Future<Either<Failure, void>> deleteTask(int id);
  Stream<List<Task>> observeTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await database.select(database.tasks).get();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      final allTasks = await database.select(database.tasks).get();
      final tasks = allTasks.where((task) {
        return task.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            task.date.isBefore(endOfDay.add(const Duration(seconds: 1)));
      }).toList();
      
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(int id) async {
    try {
      final task = await (database.select(database.tasks)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      return Right(task);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(TasksCompanion task) async {
    try {
      final id = await database.into(database.tasks).insert(task);
      final createdTask = await (database.select(database.tasks)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      return Right(createdTask);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(TasksCompanion task) async {
    try {
      await database.update(database.tasks).replace(task);
      final updatedTask = await (database.select(database.tasks)
            ..where((t) => t.id.equals(task.id.value)))
          .getSingle();
      return Right(updatedTask);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await (database.delete(database.tasks)..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<Task>> observeTasks() {
    return database.select(database.tasks).watch();
  }
}
