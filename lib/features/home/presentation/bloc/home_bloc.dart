import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/sync/domain/usecases/request_sync_use_case.dart';
import 'package:taskify/features/tasks/data/models/task_wrapper.dart';
import 'package:taskify/features/tasks/data/models/tasks_view_type.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.taskInteractor,
    required this.subTaskInteractor,
    required this.requestSyncUseCase,
  }) : super(
         HomeState(
           selectedDate: DateTime.now(),
           currentDate: DateTime.now(),
           tasks: [],
         ),
       ) {
    on<HomeStarted>(_onStarted);
    on<HomeTasksUpdated>(_onTasksUpdated);
    on<HomeUpdateTaskCompletion>(_onUpdateTaskCompletion);
    on<HomeUpdateSubTaskCompletion>(_onUpdateSubTaskCompletion);
    on<HomeChangeTasksViewType>(_onChangeTasksViewType);
    on<HomeChangeCalendarVisibility>(_onChangeCalendarVisibility);
    on<HomeSelectDate>(_onSelectDate);
  }

  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  final RequestSyncUseCase requestSyncUseCase;

  StreamSubscription<List<TaskWrapperEntity>>? _tasksSubscription;
  List<TaskWrapperEntity> _allTasks = [];

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    _observeTasks();
    requestSyncUseCase(reason: 'foreground');
  }

  void _onTasksUpdated(HomeTasksUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(tasks: event.tasks));
  }

  void _observeTasks() {
    _tasksSubscription = taskInteractor.observeTasks().listen((tasks) {
      _allTasks = tasks.toList();
      add(HomeTasksUpdated(_filterTasksByDate(_allTasks, state.selectedDate)));
    });
  }

  void _onUpdateTaskCompletion(
    HomeUpdateTaskCompletion event,
    Emitter<HomeState> emit,
  ) async {
    final task = event.task.task;
    final shouldComplete = !task.isCompleted;
    final result = await taskInteractor.updateTask(
      task.copyWith(isCompleted: shouldComplete),
    );
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag ${failure.message}'),
      ifRight: (updatedTask) => TalkerService.instance.info(
        'syncTag Task updated: ${updatedTask.id}',
      ),
    );
  }

  void _onUpdateSubTaskCompletion(
    HomeUpdateSubTaskCompletion event,
    Emitter<HomeState> emit,
  ) async {
    final subTask = event.subTask;
    final result = await subTaskInteractor.updateSubTasks([
      subTask.copyWith(isCompleted: !subTask.isCompleted),
    ]);
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag ${failure.message}'),
      ifRight: (updatedSubTasks) => TalkerService.instance.info(
        'syncTag Sub tasks updated: ${updatedSubTasks.length}',
      ),
    );
  }

  void _onChangeTasksViewType(
    HomeChangeTasksViewType event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(tasksViewType: event.tasksViewType));
  }

  void _onChangeCalendarVisibility(
    HomeChangeCalendarVisibility event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isHeaderExpanded: !state.isHeaderExpanded));
  }

  void _onSelectDate(HomeSelectDate event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedDate: event.date));
    add(HomeTasksUpdated(_filterTasksByDate(_allTasks, event.date)));
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
