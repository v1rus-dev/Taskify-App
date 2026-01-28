part of 'task_info_bloc.dart';

@freezed
class TaskInfoEvent with _$TaskInfoEvent {
  const factory TaskInfoEvent.started() = _Started;
  const factory TaskInfoEvent.taskUpdated(TaskWrapperEntity task) =
      _TaskUpdated;
  const factory TaskInfoEvent.taskCheckBoxPressed() = _TaskCheckBoxPressed;
  const factory TaskInfoEvent.subTasksUpdated(List<SubTaskEntity> subTasks) =
      _SubTasksUpdated;
  const factory TaskInfoEvent.subTaskCheckBoxPressed(SubTaskEntity subTask) =
      _SubTaskCheckBoxPressed;
}
