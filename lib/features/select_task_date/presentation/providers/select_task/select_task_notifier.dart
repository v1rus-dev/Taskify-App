import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/features/select_task_date/presentation/providers/select_task/select_task_state.dart';

final selectTaskNotifierProvider =
    NotifierProvider.family<SelectTaskNotifier, SelectTaskState, (DateTime?, bool?)>(
      (params) => SelectTaskNotifier(
        selectedDate: params.$1,
        isAllDay: params.$2,
      ),
    );

class SelectTaskNotifier extends Notifier<SelectTaskState> {
  SelectTaskNotifier({required this.selectedDate, required this.isAllDay})
    : super();

  final DateTime? selectedDate;
  final bool? isAllDay;

  @override
  SelectTaskState build() {
    return SelectTaskState(
      selectedDate: selectedDate ?? DateTime.now(),
      isAllDay: isAllDay ?? true,
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void onSelectAllDay() {
    state = state.copyWith(isAllDay: true);
  }

  void onSelectDuration() {
    state = state.copyWith(isAllDay: false);
  }
}
