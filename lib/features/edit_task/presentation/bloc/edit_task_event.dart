part of 'edit_task_bloc.dart';

@freezed
class EditTaskEvent with _$EditTaskEvent {
  const factory EditTaskEvent.started() = _Started;
  const factory EditTaskEvent.titleChanged(String title) = _TitleChanged;
  const factory EditTaskEvent.subTaskToggle(int index) = _SubTaskToggle;
  const factory EditTaskEvent.subTaskRemoved(int index) = _SubTaskRemoved;
  const factory EditTaskEvent.subTaskTextChanged(int index, String text) = _SubTaskTextChanged;
  const factory EditTaskEvent.selectDate(DateTime date, bool isAllDay, DateTime? startTime, DateTime? endTime) = _SelectDate;
  const factory EditTaskEvent.saveTask(Completer completer, String title, String description) = _SaveTask;
}