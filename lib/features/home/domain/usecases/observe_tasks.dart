import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';

class ObserveTasks {
  final TaskRepository repository;

  ObserveTasks(this.repository);

  Stream<List<TaskEntity>> call() {
    return repository.observeTasks();
  }
}