import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/entities/tasks_view_type.dart';

part 'home_screen_state.freezed.dart';

@freezed
abstract class HomeScreenState with _$HomeScreenState {
  const factory HomeScreenState({
    @Default(false) bool isHeaderExpanded,
    required DateTime selectedDate,
    required DateTime currentDate,
    required List<Task> tasks,
    @Default(TasksViewType.tasks) TasksViewType tasksViewType,
    @Default(false) bool isLoading,
    @Default('') String message,
    @Default('') String error,
  }) = _HomeScreenState;
}
