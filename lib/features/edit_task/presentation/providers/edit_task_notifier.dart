import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_state.dart';
import 'package:taskify/features/home/domain/usecases/create_task.dart';
import 'package:taskify/features/home/domain/usecases/update_task.dart';
import 'package:taskify/domain/entities/task.dart';

final editTaskNotifierProvider =
    NotifierProvider.autoDispose<EditTaskNotifier, EditTaskState>(
      () => EditTaskNotifier(
        createTask: locator<CreateTask>(),
        updateTask: locator<UpdateTask>(),
      ),
    );

class EditTaskNotifier extends Notifier<EditTaskState> {
  EditTaskNotifier({required this.createTask, required this.updateTask})
    : super() {
    TalkerService.instance.info('EditTaskNotifier initialized');
  }

  final CreateTask createTask;
  final UpdateTask updateTask;

  @override
  EditTaskState build() {
    return const EditTaskState();
  }

  void deleteTask() {
    TalkerService.instance.info('Delete task');
  }

  void saveTask({
    required String title,
    required String description,
    required Completer completer,
  }) async {
    TalkerService.instance.info('Save task: $title $description');
    final task = Task(
      title: title,
      description: description,
      createdAt: DateTime.now(),
      date: DateTime.now(),
    );
    final result = await createTask.call(task);
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
}
