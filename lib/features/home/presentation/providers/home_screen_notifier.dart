import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/entities/tasks_view_type.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/features/home/presentation/providers/home_screen_state.dart';

final homeScreenNotifierProvider =
    NotifierProvider<HomeScreenNotifier, HomeScreenState>(
  () => HomeScreenNotifier(taskInteractor: locator<TaskInteractor>()),
);

class HomeScreenNotifier extends Notifier<HomeScreenState> {
  HomeScreenNotifier({required this.taskInteractor}) : super();

  final TaskInteractor taskInteractor;
  StreamSubscription<List<TaskEntity>>? _tasksSubscription;
  List<TaskEntity> _allTasks = const [];

  @override
  HomeScreenState build() { 
    final initialSelectedDate = _normalizeDate(DateTime.now());

    _observeTasks();

    return HomeScreenState(
      isLoading: true,
      selectedDate: initialSelectedDate,
      currentDate: DateTime.now(),
      tasks: [],
    );
  }

  void updateLoading() {
    state = state.copyWith(
      isLoading: !state.isLoading,
      message: 'Home data fetched successfully',
    );
  }

  void changeCalendarState() {
    TalkerService.instance.info('Calendar currentState: ${state.isHeaderExpanded}');
    state = state.copyWith(isHeaderExpanded: !state.isHeaderExpanded);
    TalkerService.instance.info('Calendar newState: ${state.isHeaderExpanded}');
  }

  void selectDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    state = state.copyWith(
      selectedDate: normalizedDate,
      tasks: _filterTasksByDate(_allTasks, normalizedDate),
    );
  }

  void changeTasksViewType(TasksViewType tasksViewType) {
    state = state.copyWith(tasksViewType: tasksViewType);
  }

  void updateTaskCompletion(TaskEntity task) async {
    final result =
        await taskInteractor.updateTask(task.copyWith(isCompleted: !task.isCompleted));
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => TalkerService.instance.info('Task updated: ${task.id}'),
    );
  }

  Future<void> updateTasks(Completer<void> completer) async {
    await Future.delayed(const Duration(seconds: 3));
    completer.complete();
  }

  void _observeTasks() {
    _tasksSubscription = taskInteractor.observeTasks().listen((tasks) {
      _allTasks = tasks;
      TalkerService.instance.info('Tasks: ${tasks.length}');
      state = state.copyWith(tasks: _filterTasksByDate(tasks, state.selectedDate));
    });

    ref.onDispose(() {
      _tasksSubscription?.cancel();
    });
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<TaskEntity> _filterTasksByDate(List<TaskEntity> tasks, DateTime selectedDate) {
    final normalizedSelectedDate = _normalizeDate(selectedDate);
    return tasks
        .where((task) => _normalizeDate(task.date) == normalizedSelectedDate)
        .toList();
  }
}
