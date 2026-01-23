import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/tasks/models/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';

class TaskInteractor {
  TaskInteractor(this._repository);

  final TaskRepository _repository;

  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    return await _repository.getTasks();
  }

  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(
    DateTime date,
  ) async {
    return await _repository.getTasksByDate(date);
  }

  Future<Either<Failure, TaskEntity>> getTaskById(int id) async {
    return await _repository.getTaskById(id);
  }

  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    return await _repository.createTask(task);
  }

  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    return await _repository.updateTask(task);
  }

  Future<Either<Failure, void>> deleteTask(int id) async {
    return await _repository.deleteTask(id);
  }

  Stream<List<TaskWrapperEntity>> observeTasks() {
    return _repository.observeTasks();
  }
}
