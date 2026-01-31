part of 'task_info_bloc.dart';

abstract class TaskInfoEvent extends Equatable {
  const TaskInfoEvent();

  @override
  List<Object?> get props => [];
}

class TaskInfoStarted extends TaskInfoEvent {
  const TaskInfoStarted();
}

class TaskInfoTaskUpdated extends TaskInfoEvent {
  const TaskInfoTaskUpdated(this.task);

  final TaskWrapperEntity task;

  @override
  List<Object?> get props => [task];
}

class TaskInfoTaskCheckBoxPressed extends TaskInfoEvent {
  const TaskInfoTaskCheckBoxPressed();
}

class TaskInfoSubTasksUpdated extends TaskInfoEvent {
  const TaskInfoSubTasksUpdated(this.subTasks);

  final List<SubTaskEntity> subTasks;

  @override
  List<Object?> get props => [subTasks];
}

class TaskInfoSubTaskCheckBoxPressed extends TaskInfoEvent {
  const TaskInfoSubTaskCheckBoxPressed(this.subTask);

  final SubTaskEntity subTask;

  @override
  List<Object?> get props => [subTask];
}
