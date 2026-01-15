import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_state.dart';
import 'package:taskify/features/home/domain/usecases/create_task.dart';
import 'package:taskify/features/home/domain/usecases/delete_task.dart';
import 'package:taskify/features/home/domain/usecases/get_task_by_id.dart';
import 'package:taskify/features/home/domain/usecases/update_task.dart';
import 'package:taskify/domain/entities/task.dart';

final editTaskNotifierProvider =
    NotifierProvider.family<EditTaskNotifier, EditTaskState, int?>(
      (int? taskId) => EditTaskNotifier(
        taskId: taskId,
        getTaskById: locator<GetTaskById>(),
        createTask: locator<CreateTask>(),
        updateTask: locator<UpdateTask>(),
        deleteTask: locator<DeleteTask>(),
      ),
    );

class EditTaskNotifier extends Notifier<EditTaskState> {
  EditTaskNotifier({
    required this.taskId,
    required this.getTaskById,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super() {
    TalkerService.instance.info('EditTaskNotifier initialized');
  }

  final int? taskId;
  final GetTaskById getTaskById;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  @override
  EditTaskState build() {
    if (taskId != null) {
      _getTaskById(taskId: taskId!);
    }
    return EditTaskState(
      taskId: taskId,
      selectedDate: DateTime.now(),
      isAllDay: true,
    );
  }

  void onDeleteTask({required int taskId, required Completer completer}) async {
    TalkerService.instance.info('Delete task: $taskId');
    final result = await deleteTask.call(taskId);
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
    final createdAt = state.createdAt ?? now;
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
        ? await createTask.call(task)
        : await updateTask.call(task);
    result.fold(
      ifLeft: (failure) => {
        TalkerService.instance.error(failure.message),
        completer.completeError(failure),
      },
      ifRight: (task) => {
        TalkerService.instance.info('Task saved: ${task.id}'),
        completer.complete(),
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
    final result = await getTaskById.call(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => {
        TalkerService.instance.info('Task: ${task.id}'),
        state = state.copyWith(
          title: task.title,
          description: task.description ?? '',
          networkId: task.networkId,
          isCompleted: task.isCompleted,
          selectedDate: task.date,
          startTime: task.startTime,
          endTime: task.endTime,
          isAllDay: task.isAllDay,
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
        ),
      },
    );
  }
}
