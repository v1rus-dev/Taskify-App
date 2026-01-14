import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/data/models/task_model.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/home/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    final result = await localDataSource.getTasks();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => TaskModel.fromDatabase(task)).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByDate(DateTime date) async {
    final result = await localDataSource.getTasksByDate(date);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => TaskModel.fromDatabase(task)).toList()),
    );
  }

  @override
  Future<Either<Failure, Task>> getTaskById(int id) async {
    final result = await localDataSource.getTaskById(id);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (task) => Right(TaskModel.fromDatabase(task)),
    );
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final result = await localDataSource.createTask(taskModel.toDatabaseInsert());
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (createdTask) => Right(TaskModel.fromDatabase(createdTask)),
    );
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final result = await localDataSource.updateTask(taskModel.toDatabaseUpdate());
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (updatedTask) => Right(TaskModel.fromDatabase(updatedTask)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    return await localDataSource.deleteTask(id);
  }

  @override
  Stream<List<Task>> observeTasks() {
    return localDataSource.observeTasks().map((tasks) => tasks.map((task) => TaskModel.fromDatabase(task)).toList());
  }
}
