import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/home/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.updateTask(task);
  }
}
