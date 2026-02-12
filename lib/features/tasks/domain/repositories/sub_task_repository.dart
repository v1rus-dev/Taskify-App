import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';

abstract class SubTaskRepository {
  Future<Either<Failure, List<SubTaskEntity>>> insertSubTasks(
    List<SubTaskEntity> subTasks,
  );
  Future<Either<Failure, List<SubTaskEntity>>> updateSubTasks(
    List<SubTaskEntity> subTasks,
  );
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds);
  Future<Either<Failure, void>> removeSubTask(int subTaskId);
  Future<Either<Failure, List<SubTaskEntity>>> getSubTasksByTaskId(int taskId);
  Stream<List<SubTaskEntity>> observeSubTasksByTaskId(int taskId);
}
