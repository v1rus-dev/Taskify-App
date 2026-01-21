part of 'edit_task_bloc.dart';

@freezed
class EditTaskEvent with _$EditTaskEvent {
  const factory EditTaskEvent.started() = _Started;
  const factory EditTaskEvent.titleChanged(String title) = _TitleChanged;
  const factory EditTaskEvent.selectDate(DateTime date, bool isAllDay, DateTime? startTime, DateTime? endTime) = _SelectDate;
  const factory EditTaskEvent.tagsUpdated(List<TagEntity> tags) = _TagsUpdated;
  const factory EditTaskEvent.saveTask(Completer completer, String title, String description, List<SubTaskUiModel> subTasks) = _SaveTask;
  const factory EditTaskEvent.removeTag(TagEntity tag) = _RemoveTag;
}
