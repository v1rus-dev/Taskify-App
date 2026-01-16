import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';

class GetTasksByDate {
  final TaskRepository repository;

  GetTasksByDate(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call(DateTime date) async {
    return await repository.getTasksByDate(date);
  }
}
