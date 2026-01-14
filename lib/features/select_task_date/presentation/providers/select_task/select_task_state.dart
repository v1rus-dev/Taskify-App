import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_task_state.freezed.dart';

@freezed
abstract class SelectTaskState with _$SelectTaskState {
  const factory SelectTaskState({
    required DateTime selectedDate,
    @Default(false) bool isAllDay,
  }) = _SelectTaskState;
}