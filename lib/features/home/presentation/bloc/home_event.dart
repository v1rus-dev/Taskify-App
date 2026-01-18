part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.tasksUpdated(List<TaskEntity> tasks) = _TasksUpdated;
  const factory HomeEvent.updateTaskCompletion(TaskEntity task) = _UpdateTaskCompletion;
  const factory HomeEvent.changeTasksViewType(TasksViewType tasksViewType) = _ChangeTasksViewType;
  const factory HomeEvent.changeCalendarVisibility() = _ChangeCalendarVisibility;
  const factory HomeEvent.selectDate(DateTime date) = _SelectDate;
}