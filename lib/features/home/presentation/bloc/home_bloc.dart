import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:taskify/domain/tasks/models/tasks_view_type.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  final SyncCoordinator syncCoordinator;

  StreamSubscription<List<TaskWrapperEntity>>? _tasksSubscription;
  List<TaskWrapperEntity> _allTasks = [];

  HomeBloc({required this.taskInteractor, required this.subTaskInteractor, required this.syncCoordinator})
    : super(
        HomeState(
          selectedDate: DateTime.now(),
          currentDate: DateTime.now(),
          tasks: [],
        ),
      ) {
    on<_Started>(_onStarted);
    on<_TasksUpdated>(_onTasksUpdated);
    on<_UpdateTaskCompletion>(_onUpdateTaskCompletion);
    on<_ChangeTasksViewType>(_onChangeTasksViewType);
    on<_ChangeCalendarVisibility>(_onChangeCalendarVisibility);
    on<_SelectDate>(_onSelectDate);
    on<_ToogleSubTask>(_onToogleSubTask);
  }

  void _onStarted(_Started event, Emitter<HomeState> emit) {
    _observeTasks();
    syncCoordinator.onForeground();
  }

  void _onTasksUpdated(_TasksUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(tasks: event.tasks));
  }

  void _observeTasks() {
    _tasksSubscription = taskInteractor.observeTasks().listen((tasks) {
      _allTasks = tasks.toList();
      add(HomeEvent.tasksUpdated(_filterTasksByDate(_allTasks, state.selectedDate)));
    });
  }

  void _onUpdateTaskCompletion(_UpdateTaskCompletion event, Emitter<HomeState> emit) async {
    final task = event.task.task;
    final shouldComplete = !task.isCompleted;
    final result = await taskInteractor.updateTask(
      task.copyWith(isCompleted: shouldComplete),
    );
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag ${failure.message}'),
      ifRight: (task) =>
          TalkerService.instance.info('syncTag Task updated: ${task.id}'),
    );

    final hasIncompleteSubTasks =
        event.task.subTasks.any((subTask) => !subTask.isCompleted);
    if (shouldComplete && hasIncompleteSubTasks) {
      final updatedSubTasks = event.task.subTasks
          .map(
            (subTask) => subTask.isCompleted
                ? subTask
                : subTask.copyWith(isCompleted: true),
          )
          .toList();
      final subTaskResult =
          await subTaskInteractor.updateSubTasks(updatedSubTasks);
      subTaskResult.fold(
        ifLeft: (failure) =>
            TalkerService.instance.error('syncTag ${failure.message}'),
        ifRight: (subTasks) => TalkerService.instance
            .info('syncTag SubTasks updated: ${subTasks.length}'),
      );
    }
  }

  void _onChangeTasksViewType(_ChangeTasksViewType event, Emitter<HomeState> emit) {
    emit(state.copyWith(tasksViewType: event.tasksViewType));
  }

  void _onChangeCalendarVisibility(_ChangeCalendarVisibility event, Emitter<HomeState> emit) {
    emit(state.copyWith(isHeaderExpanded: !state.isHeaderExpanded));
  }

  void _onSelectDate(_SelectDate event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedDate: event.date));
    add(HomeEvent.tasksUpdated(_filterTasksByDate(_allTasks, event.date)));
  }

  void _onToogleSubTask(_ToogleSubTask event, Emitter<HomeState> emit) {
    final subTask = event.subTask;
    final result = subTaskInteractor.updateSubTasks([event.subTask.copyWith(isCompleted: !event.subTask.isCompleted)]);
  }

  List<TaskWrapperEntity> _filterTasksByDate(
    List<TaskWrapperEntity> tasks,
    DateTime selectedDate,
  ) {
    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final filtered = tasks
        .where(
          (task) =>
              DateTime(
                task.task.createdAt.year,
                task.task.createdAt.month,
                task.task.createdAt.day,
              ) ==
              normalizedSelectedDate,
        )
        .toList();
    filtered.sort(_compareTasks);
    return filtered;
  }

  int _compareTasks(TaskWrapperEntity a, TaskWrapperEntity b) {
    if (a.task.isCompleted != b.task.isCompleted) {
      return a.task.isCompleted ? 1 : -1;
    }
    return b.task.createdAt.compareTo(a.task.createdAt);
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
