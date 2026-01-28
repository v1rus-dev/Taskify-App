import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

part 'task_info_event.dart';
part 'task_info_state.dart';
part 'task_info_bloc.freezed.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  final int taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;

  StreamSubscription<TaskWrapperEntity>? _taskSubscription;

  TaskInfoBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super(_Initial()) {
    on<_Started>(_onStarted);
    on<_TaskUpdated>(_onTaskUpdated);
    on<_TaskCheckBoxPressed>(_onTaskCheckBoxPressed);
    on<_SubTaskCheckBoxPressed>(_onSubTaskCheckBoxPressed);
  }

  void _onStarted(_Started event, Emitter<TaskInfoState> emit) async {
    _observeTask();
  }

  void _onTaskUpdated(_TaskUpdated event, Emitter<TaskInfoState> emit) {
    emit(TaskInfoState.success(task: event.task));
  }

  void _onTaskCheckBoxPressed(
    _TaskCheckBoxPressed event,
    Emitter<TaskInfoState> emit,
  ) {
    final task = state.maybeWhen(success: (task) => task, orElse: () => null);
    if (task == null) return;
    taskInteractor.updateTask(
      task.task.copyWith(isCompleted: !task.task.isCompleted),
    );
  }

  void _onSubTaskCheckBoxPressed(
    _SubTaskCheckBoxPressed event,
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
          (task) => add(TaskInfoEvent.taskUpdated(task)),
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
