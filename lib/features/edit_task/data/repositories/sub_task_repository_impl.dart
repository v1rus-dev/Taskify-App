import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/edit_task/data/datasources/sub_task_local_datasource.dart';
import 'package:taskify/features/edit_task/data/mappers/sub_task_mapper.dart';
import 'package:taskify/features/edit_task/domain/entities/sub_task.dart';
import 'package:taskify/features/edit_task/domain/repositories/sub_task_repository.dart';

class SubTaskRepositoryImpl implements SubTaskRepository {
  SubTaskRepositoryImpl(this._localDataSource);

  final SubTaskLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<SubTaskEntity>>> insertSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    if (subTasks.isEmpty) {
      return const Right([]);
    }
    final result = await _localDataSource.insertSubTasks(
      subTasks.map((subTask) => subTask.toInsertCompanion()).toList(),
    );

    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (subtasks) =>
          Right(subtasks.map((subtask) => subtask.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<SubTaskEntity>>> updateSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    if (subTasks.isEmpty) {
      return const Right([]);
    }
    final hasMissingIds = subTasks.any((subTask) => subTask.id == null);
    if (hasMissingIds) {
      return const Left(ValidationFailure('Subtask id is required'));
    }
    final result = await _localDataSource.updateSubTasks(
      subTasks.map((subTask) => subTask.toUpdateCompanion()).toList(),
    );

    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (subtasks) =>
          Right(subtasks.map((subtask) => subtask.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds) async {
    return await _localDataSource.removeSubTasks(subTaskIds);
  }

  @override
  Future<Either<Failure, void>> removeSubTask(int subTaskId) async {
    return await _localDataSource.removeSubTask(subTaskId);
  }

  @override
  Future<Either<Failure, List<SubTaskEntity>>> getSubTasksByTaskId(
    int taskId,
  ) async {
    final result = await _localDataSource.getSubTasksByTaskId(taskId);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (subtasks) =>
          Right(subtasks.map((subtask) => subtask.toDomain()).toList()),
    );
  }
}
