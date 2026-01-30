part of 'edit_sub_task_bloc.dart';

@freezed
class EditSubTaskEvent with _$EditSubTaskEvent {
  const factory EditSubTaskEvent.started() = _Started;
  const factory EditSubTaskEvent.subTaskToggle(int index) = _SubTaskToggle;
  const factory EditSubTaskEvent.subTaskRemoved(int index) = _SubTaskRemoved;
  const factory EditSubTaskEvent.subTaskRemovedByLocalKey(int localKey) =
      _SubTaskRemovedByLocalKey;
  const factory EditSubTaskEvent.subTaskTextChanged(int index, String text) =
      _SubTaskTextChanged;
  const factory EditSubTaskEvent.subTaskAdded() = _SubTaskAdded;
  const factory EditSubTaskEvent.subTasksReordered(
    int oldIndex,
    int newIndex,
  ) = _SubTasksReordered;
}
