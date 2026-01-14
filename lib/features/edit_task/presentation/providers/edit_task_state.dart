import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_task_state.freezed.dart';

@freezed
abstract class EditTaskState with _$EditTaskState {
  const factory EditTaskState({
    @Default('') String title,
    @Default('') String description,
  }) = _EditTaskState;
}
