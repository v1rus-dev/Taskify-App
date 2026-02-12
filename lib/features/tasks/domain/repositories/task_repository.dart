import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/data/models/task_wrapper.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(DateTime date);
  Future<Either<Failure, TaskEntity>> getTaskById(int id);
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(int id);
  Stream<List<TaskWrapperEntity>> observeTasks();
  Stream<TaskWrapperEntity> observeTaskById(int id);
}
