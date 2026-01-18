part of 'select_task_date_bloc.dart';

@freezed
class SelectTaskDateEvent with _$SelectTaskDateEvent {
  const factory SelectTaskDateEvent.dateSelected(DateTime date) = _DateSelected;
  const factory SelectTaskDateEvent.durationTypeSelected(
    TaskDurationType type,
  ) = _DurationTypeSelected;
  const factory SelectTaskDateEvent.startTimeSelected(TimeOfDay time) =
      _StartTimeSelected;
  const factory SelectTaskDateEvent.endTimeSelected(TimeOfDay time) =
      _EndTimeSelected;
}
