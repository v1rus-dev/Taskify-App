part of 'select_task_when_bloc.dart';

@freezed
abstract class SelectTaskWhenState with _$SelectTaskWhenState {
  const factory SelectTaskWhenState({
    required DateSelection defaults,
    required DateSelection current,
  }) = _SelectTaskWhenState;
}

class DateSelection {
  const DateSelection({
    required this.selectedDate,
    required this.durationType,
    this.startTime,
    this.endTime,
  });

  final DateTime selectedDate;
  final TaskDurationType durationType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  static DateSelection defaultNow() {
    return DateSelection(
      selectedDate: DateTime.now(),
      durationType: TaskDurationType.allDay,
    );
  }

  DateSelection copyWith({
    DateTime? selectedDate,
    TaskDurationType? durationType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return DateSelection(
      selectedDate: selectedDate ?? this.selectedDate,
      durationType: durationType ?? this.durationType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  bool isSameAs(DateSelection other) {
    return _isSameDay(selectedDate, other.selectedDate) &&
        durationType == other.durationType &&
        _isSameTimeOfDay(startTime, other.startTime) &&
        _isSameTimeOfDay(endTime, other.endTime);
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool _isSameTimeOfDay(TimeOfDay? left, TimeOfDay? right) {
    if (left == null && right == null) {
      return true;
    }
    if (left == null || right == null) {
      return false;
    }
    return left.hour == right.hour && left.minute == right.minute;
  }
}
