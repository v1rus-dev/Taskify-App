part of 'select_task_when_bloc.dart';

@freezed
class SelectTaskWhenEvent with _$SelectTaskWhenEvent {
  const factory SelectTaskWhenEvent.dateSelected(DateTime date) = _DateSelected;
  const factory SelectTaskWhenEvent.durationTypeSelected(
    TaskDurationType type,
  ) = _DurationTypeSelected;
  const factory SelectTaskWhenEvent.startTimeSelected(TimeOfDay time) =
      _StartTimeSelected;
  const factory SelectTaskWhenEvent.endTimeSelected(TimeOfDay time) =
      _EndTimeSelected;
  const factory SelectTaskWhenEvent.selectionCleared() = _SelectionCleared;
}
