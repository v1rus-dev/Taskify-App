part of 'edit_task_bloc.dart';

@freezed
abstract class EditTaskState with _$EditTaskState {
  const factory EditTaskState({
    @Default('') String title,
    @Default('') String description,
    int? taskId,
    int? networkId,
    @Default(false) bool isCompleted,
    required DateTime selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    @Default(true) bool isAllDay,
    @Default(false) bool titleIsNotEmpty,
    @Default(false) bool isDateModified,
    @Default(<TagEntity>[]) List<TagEntity> selectedTags,
  }) = _EditTaskState;
}
