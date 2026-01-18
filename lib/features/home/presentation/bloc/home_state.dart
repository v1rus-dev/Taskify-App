part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isHeaderExpanded,
    required DateTime selectedDate,
    required DateTime currentDate,
    required List<TaskEntity> tasks,
    @Default(TasksViewType.tasks) TasksViewType tasksViewType,
    @Default(false) bool isLoading,
    @Default('') String message,
    @Default('') String error,
    }) = _HomeState;
}
