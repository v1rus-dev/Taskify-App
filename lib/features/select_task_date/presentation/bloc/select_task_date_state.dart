part of 'select_task_date_bloc.dart';

@freezed
abstract class SelectTaskDateState with _$SelectTaskDateState {
  const factory SelectTaskDateState({
    required DateTime selectedDate,
    @Default(TaskDurationType.allDay) TaskDurationType durationType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) = _SelectTaskDateState;
}
