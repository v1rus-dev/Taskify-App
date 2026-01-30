import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:uuid/uuid.dart';

part 'edit_sub_task_event.dart';
part 'edit_sub_task_state.dart';
part 'edit_sub_task_bloc.freezed.dart';

class EditSubTaskBloc extends Bloc<EditSubTaskEvent, EditSubTaskState> {
  final int? taskId;
  final SubTaskInteractor subTaskInteractor;
  int _nextLocalKey = 0;
  final Uuid _uuid = const Uuid();

  EditSubTaskBloc({required this.taskId, required this.subTaskInteractor})
    : super(_Initial()) {
    on<_Started>(_onStarted);
    on<_SubTaskToggle>(_onSubTaskToggle);
    on<_SubTaskRemoved>(_onSubTaskRemoved);
    on<_SubTaskRemovedByLocalKey>(_onSubTaskRemovedByLocalKey);
    on<_SubTaskTextChanged>(_onSubTaskTextChanged);
    on<_SubTaskAdded>(_onSubTaskAdded);
    on<_SubTasksReordered>(_onSubTasksReordered);
  }

  void _onStarted(_Started event, Emitter<EditSubTaskState> emit) async {
    if (taskId != null) {
      final result = await subTaskInteractor.getSubTasksByTaskId(taskId!);
      result.fold(
        ifLeft: (failure) =>
            TalkerService.instance.error('syncTag ${failure.message}'),
        ifRight: (subTasks) {
          emit(
            state.copyWith(
              subTasks: subTasks
                  .map(
                    (subTask) => SubTaskUiModel(
                      id: subTask.id,
                      localKey: _nextLocalKey++,
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

  void _onSubTaskToggle(_SubTaskToggle event, Emitter<EditSubTaskState> emit) {
    final current = state.subTasks;
    if (event.index >= current.length) {
      return;
    }
    final updated = [...current];
    final existing = updated[event.index];
    updated[event.index] = SubTaskUiModel(
      id: existing.id,
      localKey: existing.localKey,
      title: existing.title,
      isCompleted: !existing.isCompleted,
    );
    emit(state.copyWith(subTasks: updated));
  }

  void _onSubTaskRemoved(
    _SubTaskRemoved event,
    Emitter<EditSubTaskState> emit,
  ) {
    final current = state.subTasks;
    if (event.index >= current.length) {
      return;
    }
    final updated = [...current]..removeAt(event.index);
    emit(state.copyWith(subTasks: updated));
  }

  void _onSubTaskRemovedByLocalKey(
    _SubTaskRemovedByLocalKey event,
    Emitter<EditSubTaskState> emit,
  ) {
    final index =
        state.subTasks.indexWhere((item) => item.localKey == event.localKey);
    if (index == -1) {
      return;
    }
    final updated = [...state.subTasks]..removeAt(index);
    emit(state.copyWith(subTasks: updated));
  }

  void _onSubTaskTextChanged(
    _SubTaskTextChanged event,
    Emitter<EditSubTaskState> emit,
  ) {
    final current = state.subTasks;
    if (event.index < current.length) {
      final updated = [...current];
      final existing = updated[event.index];
      updated[event.index] = SubTaskUiModel(
        id: existing.id,
        localKey: existing.localKey,
        title: event.text,
        isCompleted: existing.isCompleted,
      );
      emit(state.copyWith(subTasks: updated));
      return;
    }
    if (event.index == current.length && event.text.isNotEmpty) {
      emit(
        state.copyWith(
          subTasks: [
            ...current,
            SubTaskUiModel(
              id: null,
              localKey: _nextLocalKey++,
              title: event.text,
              isCompleted: false,
            ),
          ],
        ),
      );
    }
  }

  void _onSubTaskAdded(_SubTaskAdded event, Emitter<EditSubTaskState> emit) {
    final hasEmpty = state.subTasks.any((item) => item.title.trim().isEmpty);
    if (hasEmpty) {
      return;
    }
    emit(
      state.copyWith(
        subTasks: [
          ...state.subTasks,
          SubTaskUiModel(
            id: null,
            localKey: _nextLocalKey++,
            title: '',
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  void _onSubTasksReordered(
    _SubTasksReordered event,
    Emitter<EditSubTaskState> emit,
  ) {
    final current = state.subTasks;
    if (event.oldIndex < 0 || event.oldIndex >= current.length) {
      return;
    }
    var newIndex = event.newIndex;
    if (newIndex < 0 || newIndex > current.length) {
      return;
    }
    if (newIndex > event.oldIndex) {
      newIndex -= 1;
    }
    final updated = [...current];
    final item = updated.removeAt(event.oldIndex);
    updated.insert(newIndex, item);
    emit(state.copyWith(subTasks: updated));
  }

}
