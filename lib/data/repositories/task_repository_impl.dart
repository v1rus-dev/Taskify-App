import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/mappers/task_mapper.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    final result = await localDataSource.getTasks();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => task.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(DateTime date) async {
    final result = await localDataSource.getTasksByDate(date);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => task.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(int id) async {
    final result = await localDataSource.getTaskById(id);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (task) => Right(task.toDomain()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    final dataTask = TaskDomainMapper.fromDomain(task);
    final result = await localDataSource.createTask(dataTask);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (createdTask) => Right(createdTask.toDomain()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    final dataTask = TaskDomainMapper.fromDomain(task);
    final result = await localDataSource.updateTask(dataTask);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (updatedTask) => Right(updatedTask.toDomain()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    return await localDataSource.deleteTask(id);
  }

  @override
  Stream<List<TaskEntity>> observeTasks() {
    return localDataSource.observeTasks().map((tasks) => tasks.map((task) => task.toDomain()).toList());
  }
}
