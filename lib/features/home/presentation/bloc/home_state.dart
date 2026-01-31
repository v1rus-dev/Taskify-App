part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isHeaderExpanded = false,
    required this.selectedDate,
    required this.currentDate,
    required this.tasks,
    this.tasksViewType = TasksViewType.tasks,
    this.isLoading = false,
    this.message = '',
    this.error = '',
  });

  final bool isHeaderExpanded;
  final DateTime selectedDate;
  final DateTime currentDate;
  final List<TaskWrapperEntity> tasks;
  final TasksViewType tasksViewType;
  final bool isLoading;
  final String message;
  final String error;

  HomeState copyWith({
    bool? isHeaderExpanded,
    DateTime? selectedDate,
    DateTime? currentDate,
    List<TaskWrapperEntity>? tasks,
    TasksViewType? tasksViewType,
    bool? isLoading,
    String? message,
    String? error,
  }) {
    return HomeState(
      isHeaderExpanded: isHeaderExpanded ?? this.isHeaderExpanded,
      selectedDate: selectedDate ?? this.selectedDate,
      currentDate: currentDate ?? this.currentDate,
      tasks: tasks ?? this.tasks,
      tasksViewType: tasksViewType ?? this.tasksViewType,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isHeaderExpanded,
        selectedDate,
        currentDate,
        tasks,
        tasksViewType,
        isLoading,
        message,
        error,
      ];
}
