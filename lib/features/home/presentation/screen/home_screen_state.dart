import 'package:taskify/domain/models/tasks_view_type.dart';

class HomeScreenState {

  final bool isHeaderExpanded;
  final DateTime selectedDate;
  final DateTime currentDate;
  final TasksViewType tasksViewType;
  final bool isLoading;
  final String message;
  final String error;

  HomeScreenState({
    this.isHeaderExpanded = false,
    DateTime? selectedDate,
    DateTime? currentDate,
    this.tasksViewType = TasksViewType.tasks,
    this.isLoading = false,
    this.message = '',
    this.error = '',
  })  : selectedDate = selectedDate ?? DateTime.now(),
        currentDate = currentDate ?? DateTime.now();

  HomeScreenState copyWith({
    bool? isHeaderExpanded,
    DateTime? selectedDate,
    DateTime? currentDate,
    TasksViewType? tasksViewType,
    bool? isLoading,
    String? message,
    String? error,
  }) {
    return HomeScreenState(
      isHeaderExpanded: isHeaderExpanded ?? this.isHeaderExpanded,
      selectedDate: selectedDate ?? this.selectedDate,
      currentDate: currentDate ?? this.currentDate,
      tasksViewType: tasksViewType ?? this.tasksViewType,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

}