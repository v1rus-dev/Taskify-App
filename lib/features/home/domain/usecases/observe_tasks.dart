import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/home/domain/repositories/task_repository.dart';

class ObserveTasks {
  final TaskRepository repository;

  ObserveTasks(this.repository);

  Stream<List<Task>> call() {
    return repository.observeTasks();
  }
}