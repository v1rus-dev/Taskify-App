import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/features/tasks/domain/repositories/sub_task_repository.dart';

class SubTaskInteractor {
  SubTaskInteractor(this._repository);

  final SubTaskRepository _repository;

  Future<Either<Failure, List<SubTaskEntity>>> insertSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    return await _repository.insertSubTasks(subTasks);
  }

  Future<Either<Failure, List<SubTaskEntity>>> updateSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    return await _repository.updateSubTasks(subTasks);
  }

  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds) async {
    return await _repository.removeSubTasks(subTaskIds);
  }

  Future<Either<Failure, void>> removeSubTask(int subTaskId) async {
    return await _repository.removeSubTask(subTaskId);
  }

  Future<Either<Failure, List<SubTaskEntity>>> getSubTasksByTaskId(
    int taskId,
  ) async {
    return await _repository.getSubTasksByTaskId(taskId);
  }

  Stream<List<SubTaskEntity>> observeSubTasksByTaskId(int taskId) {
    return _repository.observeSubTasksByTaskId(taskId);
  }
}
