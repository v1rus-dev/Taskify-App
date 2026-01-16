import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}
