import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/features/select_task_date/presentation/providers/calendar/calendar_state.dart';

final calendarNotifierProvider =
    NotifierProvider<CalendarNotifier, CalendarState>(
  () => CalendarNotifier(),
);

class CalendarNotifier extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    return CalendarState(dateTime: DateTime.now());
  }

  void setDate(DateTime date) {
    state = CalendarState(dateTime: date);
  }

  void goToPreviousMonth() {
    final currentDate = state.dateTime;
    state = CalendarState(
      dateTime: DateTime(currentDate.year, currentDate.month - 1, 1),
    );
  }

  void goToNextMonth() {
    final currentDate = state.dateTime;
    state = CalendarState(
      dateTime: DateTime(currentDate.year, currentDate.month + 1, 1),
    );
  }
}