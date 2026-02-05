import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_model_ui.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';

part 'edit_sub_task_event.dart';
part 'edit_sub_task_state.dart';

class EditSubTaskBloc extends Bloc<EditSubTaskEvent, EditSubTaskState> {
  final int? taskId;
  final SubTaskInteractor subTaskInteractor;
  int _nextLocalKey = 0;

  EditSubTaskBloc({required this.taskId, required this.subTaskInteractor})
    : super(const EditSubTaskState()) {
    on<EditSubTaskStarted>(_onStarted);
    on<EditSubTaskToggle>(_onSubTaskToggle);
    on<EditSubTaskRemoved>(_onSubTaskRemoved);
    on<EditSubTaskRemovedByLocalKey>(_onSubTaskRemovedByLocalKey);
    on<EditSubTaskTextChanged>(_onSubTaskTextChanged);
    on<EditSubTaskAdded>(_onSubTaskAdded);
    on<EditSubTaskReordered>(_onSubTasksReordered);
  }

  void _onStarted(
    EditSubTaskStarted event,
    Emitter<EditSubTaskState> emit,
  ) async {
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
                    (subTask) => SubTaskModelUi(
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

  void _onSubTaskToggle(
    EditSubTaskToggle event,
    Emitter<EditSubTaskState> emit,
  ) {
    final current = state.subTasks;
    if (event.index >= current.length) {
      return;
    }
    final updated = [...current];
    final existing = updated[event.index];
    updated[event.index] = SubTaskModelUi(
      id: existing.id,
      localKey: existing.localKey,
      title: existing.title,
      isCompleted: !existing.isCompleted,
    );
    emit(state.copyWith(subTasks: updated));
  }

  void _onSubTaskRemoved(
    EditSubTaskRemoved event,
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
    EditSubTaskRemovedByLocalKey event,
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
    EditSubTaskTextChanged event,
    Emitter<EditSubTaskState> emit,
  ) {
    final current = state.subTasks;
    if (event.index < current.length) {
      final updated = [...current];
      final existing = updated[event.index];
      updated[event.index] = SubTaskModelUi(
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
            SubTaskModelUi(
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

  void _onSubTaskAdded(
    EditSubTaskAdded event,
    Emitter<EditSubTaskState> emit,
  ) {
    final hasEmpty = state.subTasks.any((item) => item.title.trim().isEmpty);
    if (hasEmpty) {
      return;
    }
    emit(
      state.copyWith(
        subTasks: [
          ...state.subTasks,
          SubTaskModelUi(
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
    EditSubTaskReordered event,
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
