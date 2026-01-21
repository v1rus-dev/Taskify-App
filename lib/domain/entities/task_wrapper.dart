import 'package:equatable/equatable.dart';
import 'package:taskify/domain/entities/sub_task.dart';
import 'package:taskify/domain/entities/tag.dart';
import 'package:taskify/domain/entities/task.dart';

class TaskWrapperEntity extends Equatable {
  const TaskWrapperEntity({
    required this.task,
    required this.subTasks,
    required this.tags,
  });

  final TaskEntity task;
  final List<SubTaskEntity> subTasks;
  final List<TagEntity> tags;

  TaskWrapperEntity copyWith({
    TaskEntity? task,
    List<SubTaskEntity>? subTasks,
    List<TagEntity>? tags,
  }) {
    return TaskWrapperEntity(
      task: task ?? this.task,
      subTasks: subTasks ?? this.subTasks,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [task, subTasks, tags];
}
