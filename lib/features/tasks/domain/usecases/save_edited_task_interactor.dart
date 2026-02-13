import 'package:dart_either/dart_either.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/data/models/task_recurrence.dart';
import 'package:taskify/features/tasks/data/models/task_reminder.dart';
import 'package:taskify/features/tasks/domain/models/sub_task_draft.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

class SaveEditedTaskParams extends Equatable {
  const SaveEditedTaskParams({
    required this.taskId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.recurrence,
    required this.reminder,
    required this.createdAt,
    required this.tags,
    required this.subTasks,
    required this.shouldSyncTags,
    required this.shouldUpsertTask,
  });

  final int? taskId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime selectedDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final TaskRecurrence? recurrence;
  final TaskReminder? reminder;
  final DateTime? createdAt;
  final List<TagEntity> tags;
  final List<SubTaskDraft> subTasks;
  final bool shouldSyncTags;
  final bool shouldUpsertTask;

  @override
  List<Object?> get props => [
    taskId,
    title,
    description,
    isCompleted,
    selectedDate,
    startTime,
    endTime,
    isAllDay,
    recurrence,
    reminder,
    createdAt,
    tags,
    subTasks,
    shouldSyncTags,
    shouldUpsertTask,
  ];
}

class SaveEditedTaskResult extends Equatable {
  const SaveEditedTaskResult({required this.task});

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

class SaveEditedTaskInteractor {
  SaveEditedTaskInteractor(
    this._taskInteractor,
    this._subTaskInteractor,
    this._tagInteractor,
  );

  final TaskInteractor _taskInteractor;
  final SubTaskInteractor _subTaskInteractor;
  final TagInteractor _tagInteractor;

  Future<Either<Failure, SaveEditedTaskResult>> call(
    SaveEditedTaskParams params,
  ) async {
    final resolvedTaskId = params.taskId;
    Failure? failure;
    TaskEntity? savedTask;

    if (params.shouldUpsertTask) {
      if (resolvedTaskId == null) {
        final result = await _taskInteractor.createTask(
          TaskEntity(
            title: params.title,
            description: params.description,
            date: params.selectedDate,
            recurrence: params.recurrence,
            reminder: params.reminder,
            createdAt: params.createdAt ?? DateTime.now(),
          ),
        );
        result.fold(
          ifLeft: (error) => failure = error,
          ifRight: (task) => savedTask = task,
        );
        if (failure != null) {
          return Left(failure!);
        }
      } else {
        final result = await _taskInteractor.updateTask(
          TaskEntity(
            id: resolvedTaskId,
            title: params.title,
            description: params.description,
            date: params.selectedDate,
            recurrence: params.recurrence,
            reminder: params.reminder,
            createdAt: params.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        result.fold(
          ifLeft: (error) => failure = error,
          ifRight: (task) => savedTask = task,
        );
        if (failure != null) {
          return Left(failure!);
        }
      }
    }

    final taskIdResolved = savedTask?.id ?? resolvedTaskId;
    if (taskIdResolved == null) {
      return const Left(ValidationFailure('Task id is required'));
    }

    final syncResult = await _syncSubTasks(
      taskId: taskIdResolved,
      subTasks: params.subTasks,
    );
    Failure? syncFailure;
    syncResult.fold(ifLeft: (error) => syncFailure = error, ifRight: (_) {});
    if (syncFailure != null) {
      return Left(syncFailure!);
    }

    if (params.shouldSyncTags) {
      final tagResult = await _tagInteractor.setTaskTags(
        taskIdResolved,
        params.tags,
      );
      Failure? tagFailure;
      tagResult.fold(ifLeft: (error) => tagFailure = error, ifRight: (_) {});
      if (tagFailure != null) {
        return Left(tagFailure!);
      }
    }

    final resolvedTask =
        savedTask ??
        TaskEntity(
          id: taskIdResolved,
          title: params.title,
          description: params.description,
          date: params.selectedDate,
          recurrence: params.recurrence,
          reminder: params.reminder,
          createdAt: params.createdAt ?? DateTime.now(),
          updatedAt: params.shouldUpsertTask ? DateTime.now() : null,
        );

    return Right(SaveEditedTaskResult(task: resolvedTask));
  }

  Future<Either<Failure, void>> _syncSubTasks({
    required int taskId,
    required List<SubTaskDraft> subTasks,
  }) async {
    final normalizedSubTasks = subTasks
        .where((item) => item.title.trim().isNotEmpty)
        .toList();
    final existingResult = await _subTaskInteractor.getSubTasksByTaskId(taskId);
    Failure? failure;
    List<SubTaskEntity> existing = const [];
    existingResult.fold(
      ifLeft: (error) => failure = error,
      ifRight: (items) => existing = items,
    );
    if (failure != null) {
      return Left(failure!);
    }

    final existingById = <int, SubTaskEntity>{};
    for (final item in existing) {
      if (item.id != null) {
        existingById[item.id!] = item;
      }
    }
    final existingIds = existingById.keys.toSet();
    final incomingIds = normalizedSubTasks
        .where((item) => item.id != null)
        .map((e) => e.id!)
        .toSet();

    final toDeleteIds = existingIds.difference(incomingIds).toList();
    final toUpdate = <SubTaskEntity>[];
    for (final item in normalizedSubTasks) {
      final id = item.id;
      if (id == null || !existingIds.contains(id)) {
        continue;
      }
      final existingItem = existingById[id];
      if (existingItem == null) {
        continue;
      }
      if (existingItem.title == item.title &&
          existingItem.isCompleted == item.isCompleted) {
        continue;
      }
      toUpdate.add(
        SubTaskEntity(
          id: id,
          taskId: taskId,
          title: item.title,
          isCompleted: item.isCompleted,
        ),
      );
    }
    final toInsert = normalizedSubTasks
        .where((item) => item.id == null || !existingIds.contains(item.id))
        .map(
          (item) => SubTaskEntity(
            id: null,
            taskId: taskId,
            title: item.title,
            isCompleted: item.isCompleted,
          ),
        )
        .toList();

    if (toUpdate.isNotEmpty) {
      final updateResult = await _subTaskInteractor.updateSubTasks(toUpdate);
      Failure? updateFailure;
      updateResult.fold(
        ifLeft: (error) => updateFailure = error,
        ifRight: (_) {},
      );
      if (updateFailure != null) {
        return Left(updateFailure!);
      }
    }

    if (toInsert.isNotEmpty) {
      final insertResult = await _subTaskInteractor.insertSubTasks(toInsert);
      Failure? insertFailure;
      insertResult.fold(
        ifLeft: (error) => insertFailure = error,
        ifRight: (_) {},
      );
      if (insertFailure != null) {
        return Left(insertFailure!);
      }
    }

    if (toDeleteIds.isNotEmpty) {
      final deleteResult = await _subTaskInteractor.removeSubTasks(toDeleteIds);
      Failure? deleteFailure;
      deleteResult.fold(
        ifLeft: (error) => deleteFailure = error,
        ifRight: (_) {},
      );
      if (deleteFailure != null) {
        return Left(deleteFailure!);
      }
    }

    return const Right(null);
  }
}
