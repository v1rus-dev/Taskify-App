import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'dart:async';

part 'edit_task_event.dart';
part 'edit_task_state.dart';
part 'edit_task_bloc.freezed.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final int? taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  DateTime? _createdAt;
  List<int> _initialSubTaskIds = const [];

  EditTaskBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_TitleChanged>(_onTitleChanged);
    on<_SelectDate>(_onSelectDate);
    on<_SubTaskToggle>(_onSubTaskToggle);
    on<_SubTaskRemoved>(_onSubTaskRemoved);
    on<_SubTaskTextChanged>(_onSubTaskTextChanged);
    on<_SaveTask>(_onSaveTask);
  }

  Future<void> _onStarted(_Started event, Emitter<EditTaskState> emit) async {
    emit(
      EditTaskState.loaded(
        '',
        '',
        taskId,
        null,
        false,
        DateTime.now(),
        null,
        null,
        true,
        false,
        const [],
      ),
    );
    if (taskId != null) {
      await _getTaskById(taskId: taskId!, emit: emit);
      await _loadSubTasks(taskId: taskId!, emit: emit);
    }
  }

  void _onTitleChanged(_TitleChanged event, Emitter<EditTaskState> emit) {
    final loadedState = state.loadedOrNull;
    if (loadedState == null) {
      return;
    }
    emit(
      loadedState.copyWith(
        title: event.title,
        titleIsNotEmpty: event.title.trim().isNotEmpty,
      ),
    );
  }

  void _onSelectDate(_SelectDate event, Emitter<EditTaskState> emit) {
    final loadedState = state.loadedOrNull;
    if (loadedState == null) {
      return;
    }
    final resolvedStartTime = event.isAllDay ? null : event.startTime;
    final resolvedEndTime = event.isAllDay ? null : event.endTime;
    emit(
      loadedState.copyWith(
        selectedDate: event.date,
        startTime: resolvedStartTime,
        endTime: resolvedEndTime,
        isAllDay: event.isAllDay,
      ),
    );
  }

  void _onSubTaskToggle(_SubTaskToggle event, Emitter<EditTaskState> emit) {
    final loadedState = state.loadedOrNull;
    if (loadedState == null) {
      return;
    }
    final current = loadedState.subTasks;
    if (event.index >= current.length) {
      return;
    }
    final updated = [...current];
    final existing = updated[event.index];
    updated[event.index] = SubTaskUiModel(
      id: existing.id,
      title: existing.title,
      isCompleted: !existing.isCompleted,
    );
    emit(loadedState.copyWith(subTasks: updated));
  }

  void _onSubTaskRemoved(_SubTaskRemoved event, Emitter<EditTaskState> emit) {
    final loadedState = state.loadedOrNull;
    if (loadedState == null) {
      return;
    }
    final current = loadedState.subTasks;
    if (event.index >= current.length) {
      return;
    }
    final updated = [...current]..removeAt(event.index);
    emit(loadedState.copyWith(subTasks: updated));
  }

  void _onSubTaskTextChanged(_SubTaskTextChanged event, Emitter<EditTaskState> emit) {
    final loadedState = state.loadedOrNull;
    if (loadedState == null) {
      return;
    }
    final current = loadedState.subTasks;
    if (event.index < current.length) {
      final updated = [...current];
      final existing = updated[event.index];
      updated[event.index] = SubTaskUiModel(
        id: existing.id,
        title: event.text,
        isCompleted: existing.isCompleted,
      );
      emit(loadedState.copyWith(subTasks: updated));
      return;
    }
    if (event.index == current.length && event.text.isNotEmpty) {
      emit(
        loadedState.copyWith(
          subTasks: [
            ...current,
            SubTaskUiModel(id: null, title: event.text, isCompleted: false),
          ],
        ),
      );
    }
  }

  Future<void> _onSaveTask(_SaveTask event, Emitter<EditTaskState> emit) async {
    final completer = event.completer;
    completer.complete();
  }

  Future<void> _getTaskById({
    required int taskId,
    required Emitter<EditTaskState> emit,
  }) async {
    final result = await taskInteractor.getTaskById(taskId);

    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) {
        TalkerService.instance.info('Task: ${task.id}');
        _createdAt = task.createdAt;
        final loadedState = state.loadedOrNull;
        if (loadedState == null) {
          return;
        }
        emit(
          loadedState.copyWith(
            title: task.title,
            titleIsNotEmpty: task.title.trim().isNotEmpty,
            description: task.description ?? '',
            taskId: task.id,
            networkId: task.networkId,
            isCompleted: task.isCompleted,
            selectedDate: task.date,
            startTime: task.startTime,
            endTime: task.endTime,
            isAllDay: task.isAllDay,
          ),
        );
      },
    );
  }

  Future<void> _loadSubTasks({
    required int taskId,
    required Emitter<EditTaskState> emit,
  }) async {
    final result = await subTaskInteractor.getSubTasksByTaskId(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (subTasks) {
        TalkerService.instance.info('SubTasks: ${subTasks.length}');
        _initialSubTaskIds = subTasks
            .map((subTask) => subTask.id)
            .whereType<int>()
            .toList();
        final loadedState = state.loadedOrNull;
        if (loadedState == null) {
          return;
        }
        emit(
          loadedState.copyWith(
            subTasks: subTasks
                .map(
                  (subTask) => SubTaskUiModel(
                    id: subTask.id,
                    title: subTask.title,
                    isCompleted: subTask.isCompleted,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
