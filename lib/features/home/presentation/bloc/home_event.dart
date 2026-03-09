part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeTasksUpdated extends HomeEvent {
  const HomeTasksUpdated(this.tasks);

  final List<TaskWrapperEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

class HomeUpdateTaskCompletion extends HomeEvent {
  const HomeUpdateTaskCompletion(this.task);

  final TaskWrapperEntity task;

  @override
  List<Object?> get props => [task];
}

class HomeUpdateSubTaskCompletion extends HomeEvent {
  const HomeUpdateSubTaskCompletion(this.subTask);

  final SubTaskEntity subTask;

  @override
  List<Object?> get props => [subTask];
}

class HomeChangeTasksViewType extends HomeEvent {
  const HomeChangeTasksViewType(this.tasksViewType);

  final TasksViewType tasksViewType;

  @override
  List<Object?> get props => [tasksViewType];
}

class HomeChangeCalendarVisibility extends HomeEvent {
  const HomeChangeCalendarVisibility();
}

class HomeSelectDate extends HomeEvent {
  const HomeSelectDate(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}
