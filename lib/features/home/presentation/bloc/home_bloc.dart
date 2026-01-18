import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/entities/tasks_view_type.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskInteractor taskInteractor;

  StreamSubscription<List<TaskEntity>>? _tasksSubscription;
  List<TaskEntity> _allTasks = [];

  HomeBloc({required this.taskInteractor})
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
  }

  void _onStarted(_Started event, Emitter<HomeState> emit) {
    _observeTasks();
  }

  void _onTasksUpdated(_TasksUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(tasks: event.tasks));
  }

  void _observeTasks() {
    _tasksSubscription = taskInteractor.observeTasks().listen((tasks) {
      _allTasks = tasks;
      TalkerService.instance.info('Tasks: ${tasks.length}');
      add(HomeEvent.tasksUpdated(_filterTasksByDate(tasks, state.selectedDate)));
    });
  }

  void _onUpdateTaskCompletion(_UpdateTaskCompletion event, Emitter<HomeState> emit) async {
    final task = event.task;
    final result = await taskInteractor.updateTask(task.copyWith(isCompleted: !task.isCompleted));
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => TalkerService.instance.info('Task updated: ${task.id}'),
    );
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

  List<TaskEntity> _filterTasksByDate(
    List<TaskEntity> tasks,
    DateTime selectedDate,
  ) {
    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return tasks
        .where(
          (task) =>
              DateTime(task.date.year, task.date.month, task.date.day) ==
              normalizedSelectedDate,
        )
        .toList();
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
