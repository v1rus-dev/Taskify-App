import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/domain/entities/sub_task.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_state.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/domain/entities/task.dart';

final editTaskNotifierProvider = NotifierProvider.autoDispose
    .family<EditTaskNotifier, EditTaskState, int?>(
      (int? taskId) => EditTaskNotifier(
        taskId: taskId,
        taskInteractor: locator<TaskInteractor>(),
        subTaskInteractor: locator<SubTaskInteractor>(),
      ),
    );

class EditTaskNotifier extends Notifier<EditTaskState> {
  EditTaskNotifier({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super() {
    if (taskId != null) {
      _getTaskById(taskId: taskId!);
      _loadSubTasks(taskId: taskId!);
    }
  }

  final int? taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  DateTime? _createdAt;
  List<int> _initialSubTaskIds = const [];

  @override
  EditTaskState build() {
    TalkerService.instance.info('EditTaskNotifier build');
    return EditTaskState(
      taskId: taskId,
      selectedDate: DateTime.now(),
      isAllDay: true,
    );
  }

  void onDeleteTask({required int taskId, required Completer completer}) async {
    TalkerService.instance.info('Delete task: $taskId');
    final result = await taskInteractor.deleteTask(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (_) => {
        TalkerService.instance.info('Task deleted'),
        completer.complete(),
      },
    );
  }

  void onSaveTask({
    required String title,
    required String description,
    required Completer completer,
  }) async {
    TalkerService.instance.info('Save task: $title $description');
    final now = DateTime.now();
    final selectedDate = state.selectedDate ?? now;
    final createdAt = _createdAt ?? now;
    final updatedAt = taskId != null ? now : null;
    final task = TaskEntity(
      id: taskId,
      networkId: state.networkId,
      title: title,
      description: description,
      isCompleted: state.isCompleted,
      date: selectedDate,
      startTime: state.startTime,
      endTime: state.endTime,
      isAllDay: state.isAllDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
    final result = taskId == null
        ? await taskInteractor.createTask(task)
        : await taskInteractor.updateTask(task);
    result.fold(
      ifLeft: (failure) => {
        TalkerService.instance.error(failure.message),
        completer.completeError(failure),
      },
      ifRight: (savedTask) async {
        final subTaskResult = await _saveSubTasks(taskId: savedTask.id);
        Failure? subTaskFailure;
        subTaskResult.fold(
          ifLeft: (left) => subTaskFailure = left,
          ifRight: (_) {},
        );
        if (subTaskFailure != null) {
          TalkerService.instance.error(subTaskFailure!.message);
          completer.completeError(subTaskFailure!);
          return;
        }
        TalkerService.instance.info('Task saved: ${savedTask.id}');
        completer.complete();
      },
    );
  }

  void onSelectDate({
    required DateTime selectedDate,
    required bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final resolvedStartTime = isAllDay ? null : startTime;
    final resolvedEndTime = isAllDay ? null : endTime;
    state = state.copyWith(
      selectedDate: selectedDate,
      startTime: resolvedStartTime,
      endTime: resolvedEndTime,
      isAllDay: isAllDay,
    );
  }

  void _getTaskById({required int taskId}) async {
    final result = await taskInteractor.getTaskById(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => {
        TalkerService.instance.info('Task: ${task.id}'),
        _createdAt = task.createdAt,
        state = state.copyWith(
          title: task.title,
          titleIsNotEmpty: task.title.trim().isNotEmpty,
          description: task.description ?? '',
          networkId: task.networkId,
          isCompleted: task.isCompleted,
          selectedDate: task.date,
          startTime: task.startTime,
          endTime: task.endTime,
          isAllDay: task.isAllDay,
        ),
      },
    );
  }

  void _loadSubTasks({required int taskId}) async {
    final result = await subTaskInteractor.getSubTasksByTaskId(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (subTasks) => {
        _initialSubTaskIds = subTasks
            .map((subTask) => subTask.id)
            .whereType<int>()
            .toList(),
        state = state.copyWith(
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
      },
    );
  }

  Future<Either<Failure, void>> _saveSubTasks({required int? taskId}) async {
    if (taskId == null) {
      return const Left(ValidationFailure('Task id is required'));
    }

    final uiSubTasks = state.subTasks
        .map((subTask) => subTask.title.trim().isEmpty ? null : subTask)
        .whereType<SubTaskUiModel>()
        .toList();

    final existing = uiSubTasks
        .where((subTask) => subTask.id != null)
        .map(
          (subTask) => SubTaskEntity(
            id: subTask.id,
            taskId: taskId,
            title: subTask.title,
            isCompleted: subTask.isCompleted,
          ),
        )
        .toList();

    final created = uiSubTasks
        .where((subTask) => subTask.id == null)
        .map(
          (subTask) => SubTaskEntity(
            taskId: taskId,
            title: subTask.title,
            isCompleted: subTask.isCompleted,
          ),
        )
        .toList();

    if (existing.isNotEmpty) {
      final updateResult = await subTaskInteractor.updateSubTasks(existing);
      Failure? updateFailure;
      updateResult.fold(
        ifLeft: (left) => updateFailure = left,
        ifRight: (_) {},
      );
      if (updateFailure != null) {
        return Left(updateFailure!);
      }
    }

    if (created.isNotEmpty) {
      final insertResult = await subTaskInteractor.insertSubTasks(created);
      Failure? insertFailure;
      insertResult.fold(
        ifLeft: (left) => insertFailure = left,
        ifRight: (_) {},
      );
      if (insertFailure != null) {
        return Left(insertFailure!);
      }
    }

    final currentIds = existing
        .map((subTask) => subTask.id)
        .whereType<int>()
        .toSet();
    final removedIds = _initialSubTaskIds
        .where((id) => !currentIds.contains(id))
        .toList();
    if (removedIds.isNotEmpty) {
      final removeResult = await subTaskInteractor.removeSubTasks(removedIds);
      Failure? removeFailure;
      removeResult.fold(
        ifLeft: (left) => removeFailure = left,
        ifRight: (_) {},
      );
      if (removeFailure != null) {
        return Left(removeFailure!);
      }
    }

    _initialSubTaskIds = currentIds.toList();
    return const Right(null);
  }

  void onSubTaskTextChanged({required int index, required String text}) {
    final current = state.subTasks;
    if (index < current.length) {
      final updated = [...current];
      final existing = updated[index];
      updated[index] = SubTaskUiModel(
        id: existing.id,
        title: text,
        isCompleted: existing.isCompleted,
      );
      state = state.copyWith(subTasks: updated);
      return;
    }

    if (index == current.length && text.isNotEmpty) {
      state = state.copyWith(
        subTasks: [
          ...current,
          SubTaskUiModel(id: null, title: text, isCompleted: false),
        ],
      );
    }
  }

  void onTitleChanged(String value) {
    TalkerService.instance.info('Title changed: $value');
    state = state.copyWith(
      title: value,
      titleIsNotEmpty: value.trim().isNotEmpty,
    );
  }

  void onSubTaskToggle({required int index}) {
    final current = state.subTasks;
    if (index >= current.length) {
      return;
    }
    final updated = [...current];
    final existing = updated[index];
    updated[index] = SubTaskUiModel(
      id: existing.id,
      title: existing.title,
      isCompleted: !existing.isCompleted,
    );
    state = state.copyWith(subTasks: updated);
  }

  void onSubTaskRemoved({required int index}) {
    final current = state.subTasks;
    if (index >= current.length) {
      return;
    }
    final updated = [...current]..removeAt(index);
    state = state.copyWith(subTasks: updated);
  }
}
