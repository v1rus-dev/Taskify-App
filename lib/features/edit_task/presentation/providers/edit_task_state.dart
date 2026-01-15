import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_task_state.freezed.dart';

@freezed
abstract class EditTaskState with _$EditTaskState {
  const factory EditTaskState({
    @Default('') String title,
    @Default('') String description,
    @Default(null) int? taskId,
    int? networkId,
    @Default(false) bool isCompleted,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    @Default(true) bool isAllDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EditTaskState;
}
