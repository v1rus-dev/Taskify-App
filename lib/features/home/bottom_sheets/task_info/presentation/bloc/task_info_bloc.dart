import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/features/tasks/data/models/task_wrapper.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

part 'task_info_event.dart';
part 'task_info_state.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  final int taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;

  StreamSubscription<TaskWrapperEntity>? _taskSubscription;

  TaskInfoBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super(const TaskInfoInitial()) {
    on<TaskInfoStarted>(_onStarted);
    on<TaskInfoTaskUpdated>(_onTaskUpdated);
    on<TaskInfoTaskCheckBoxPressed>(_onTaskCheckBoxPressed);
    on<TaskInfoSubTaskCheckBoxPressed>(_onSubTaskCheckBoxPressed);
  }

  void _onStarted(TaskInfoStarted event, Emitter<TaskInfoState> emit) async {
    _observeTask();
  }

  void _onTaskUpdated(TaskInfoTaskUpdated event, Emitter<TaskInfoState> emit) {
    emit(TaskInfoSuccess(task: event.task));
  }

  void _onTaskCheckBoxPressed(
    TaskInfoTaskCheckBoxPressed event,
    Emitter<TaskInfoState> emit,
  ) {
    final current = state;
    if (current is! TaskInfoSuccess) {
      return;
    }
    taskInteractor.updateTask(
      current.task.task.copyWith(isCompleted: !current.task.task.isCompleted),
    );
  }

  void _onSubTaskCheckBoxPressed(
    TaskInfoSubTaskCheckBoxPressed event,
    Emitter<TaskInfoState> emit,
  ) {
    final subTask = event.subTask;
    subTaskInteractor.updateSubTasks([
      subTask.copyWith(isCompleted: !subTask.isCompleted),
    ]);
  }

  void _observeTask() {
    _taskSubscription = taskInteractor
        .observeTaskById(taskId)
        .listen(
          (task) => add(TaskInfoTaskUpdated(task)),
          onError: (error, _) {
            TalkerService.instance.error(
              'syncTag observeTaskById error',
              error,
            );
          },
        );
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
