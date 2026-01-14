import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/entities/tasks_view_type.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/home/domain/usecases/observe_tasks.dart';
import 'package:taskify/features/home/domain/usecases/update_task.dart';
import 'package:taskify/features/home/presentation/providers/home_screen_state.dart';

final homeScreenNotifierProvider =
    NotifierProvider<HomeScreenNotifier, HomeScreenState>(
  () => HomeScreenNotifier(observeTasks: locator<ObserveTasks>(), updateTask: locator<UpdateTask>()),
);

class HomeScreenNotifier extends Notifier<HomeScreenState> {
  HomeScreenNotifier({required this.observeTasks, required this.updateTask}) : super();

  final ObserveTasks observeTasks;
  final UpdateTask updateTask;
  StreamSubscription<List<TaskEntity>>? _tasksSubscription;

  @override
  HomeScreenState build() { 

    _observeTasks();

    return HomeScreenState(
      isLoading: true,
      selectedDate: DateTime.now(),
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
    state = state.copyWith(selectedDate: date);
  }

  void changeTasksViewType(TasksViewType tasksViewType) {
    state = state.copyWith(tasksViewType: tasksViewType);
  }

  void updateTaskCompletion(TaskEntity task) async {
    final result = await updateTask.call(task.copyWith(isCompleted: !task.isCompleted));
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => TalkerService.instance.info('Task updated: ${task.id}'),
    );
  }

  void _observeTasks() {
    _tasksSubscription = observeTasks.call().listen((tasks) {
      TalkerService.instance.info('Tasks: ${tasks.length}');
      state = state.copyWith(tasks: tasks);
    });

    ref.onDispose(() {
      _tasksSubscription?.cancel();
    });
  }
}
