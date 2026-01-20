import 'package:equatable/equatable.dart';
import 'package:taskify/domain/entities/sub_task.dart';
import 'package:taskify/domain/entities/task.dart';

class TaskWithSubTasksEntity extends Equatable {
  const TaskWithSubTasksEntity({
    required this.task,
    required this.subTasks,
  });

  final TaskEntity task;
  final List<SubTaskEntity> subTasks;

  TaskWithSubTasksEntity copyWith({
    TaskEntity? task,
    List<SubTaskEntity>? subTasks,
  }) {
    return TaskWithSubTasksEntity(
      task: task ?? this.task,
      subTasks: subTasks ?? this.subTasks,
    );
  }

  @override
  List<Object?> get props => [task, subTasks];
}
