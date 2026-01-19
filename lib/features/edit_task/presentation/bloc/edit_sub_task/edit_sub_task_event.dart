part of 'edit_sub_task_bloc.dart';

@freezed
class EditSubTaskEvent with _$EditSubTaskEvent {
  const factory EditSubTaskEvent.started() = _Started;
  const factory EditSubTaskEvent.subTaskToggle(int index) = _SubTaskToggle;
  const factory EditSubTaskEvent.subTaskRemoved(int index) = _SubTaskRemoved;
  const factory EditSubTaskEvent.subTaskTextChanged(int index, String text) =
      _SubTaskTextChanged;
  const factory EditSubTaskEvent.saveSubTasks(Completer completer) = _SaveSubTasks;
}
