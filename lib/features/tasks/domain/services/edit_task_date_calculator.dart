import 'package:flutter/material.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_snapshots.dart';

class EditTaskDateCalculator {
  const EditTaskDateCalculator();

  static const defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const defaultEndTime = TimeOfDay(hour: 10, minute: 0);

  ResolvedTimes resolveTimes({
    required DateTime selectedDate,
    required bool isAllDay,
    required DateTime? startTime,
    required DateTime? endTime,
  }) {
    if (isAllDay) {
      return const ResolvedTimes();
    }
    final resolvedStart = _normalizeTime(
      selectedDate,
      startTime ?? combineDateAndTime(selectedDate, defaultStartTime),
    );
    final resolvedEnd = _normalizeTime(
      selectedDate,
      endTime ?? combineDateAndTime(selectedDate, defaultEndTime),
    );
    return ResolvedTimes(startTime: resolvedStart, endTime: resolvedEnd);
  }

  DateTime withDate(DateTime source, DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      source.hour,
      source.minute,
    );
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool isSameTimeOfDay(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return true;
    }
    if (left == null || right == null) {
      return false;
    }
    return left.hour == right.hour && left.minute == right.minute;
  }

  bool isDateModified({
    required DateSelectionSnapshot current,
    required DateSelectionSnapshot initial,
  }) {
    if (!isSameDay(current.selectedDate, initial.selectedDate)) {
      return true;
    }
    if (current.isAllDay != initial.isAllDay) {
      return true;
    }
    if (!isSameTimeOfDay(current.startTime, initial.startTime)) {
      return true;
    }
    if (!isSameTimeOfDay(current.endTime, initial.endTime)) {
      return true;
    }
    return false;
  }

  DateTime _normalizeTime(DateTime date, DateTime source) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      source.hour,
      source.minute,
    );
  }
}

class ResolvedTimes {
  const ResolvedTimes({this.startTime, this.endTime});

  final DateTime? startTime;
  final DateTime? endTime;
}
