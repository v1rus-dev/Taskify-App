import 'dart:async';

import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/features/tasks/data/mappers/task_mapper.dart';
import 'package:taskify/features/tasks/data/mappers/tag_mapper.dart';
import 'package:taskify/features/tasks/data/models/task_wrapper.dart';
import 'package:taskify/features/tasks/domain/models/default_tag.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';
import 'package:taskify/features/tasks/data/sources/task_local_datasource.dart';
import 'package:taskify/features/tasks/data/sources/sub_task_local_datasource.dart';
import 'package:taskify/features/tasks/data/sources/tag_local_datasource.dart';
import 'package:taskify/features/tasks/data/mappers/sub_task_mapper.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskify/domain/sync/models/sync_op_data_entity.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry_entity.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final SubTaskLocalDataSource subTaskLocalDataSource;
  final TagLocalDataSource tagLocalDataSource;
  final SyncRepository syncRepository;
  final SyncCoordinator syncCoordinator;
  final Uuid _uuid = const Uuid();
  static final Map<int, DefaultTagEntity> _defaultTagsById = {
    for (final tag in DefaultTag.values)
      tag.id: DefaultTagEntity(defaultTag: tag),
  };

  TaskRepositoryImpl(
    this.localDataSource,
    this.subTaskLocalDataSource,
    this.tagLocalDataSource,
    this.syncRepository,
    this.syncCoordinator,
  );

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    final result = await localDataSource.getTasks();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => task.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(DateTime date) async {
    final result = await localDataSource.getTasksByDate(date);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tasks) => Right(tasks.map((task) => task.toDomain()).toList()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(int id) async {
    final result = await localDataSource.getTaskById(id);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (task) => Right(task.toDomain()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    final clientId = task.clientId ?? _uuid.v4();
    final dataTask = TaskDomainMapper.toInsertCompanion(
      task.copyWith(clientId: clientId),
    );
    final result = await localDataSource.createTask(dataTask);
    Failure? failure;
    TaskEntity? created;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => created = right.toDomain(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    await _enqueueTaskOp(task: created!, op: 'create');
    syncCoordinator.scheduleSync(reason: 'task_create');
    return Right(created!);
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    final dataTask = TaskDomainMapper.fromDomain(task);
    final result = await localDataSource.updateTask(dataTask);
    Failure? failure;
    TaskEntity? updated;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) => updated = right.toDomain(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    await _enqueueTaskOp(task: updated!, op: 'update');
    syncCoordinator.scheduleSync(reason: 'task_update');
    return Right(updated!);
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    final existing = await localDataSource.getTaskById(id);
    TaskEntity? task;
    existing.fold(
      ifLeft: (_) {},
      ifRight: (value) => task = value.toDomain(),
    );
    final result = await localDataSource.deleteTask(id);
    await result.fold(
      ifLeft: (_) async {},
      ifRight: (_) async {
        await _enqueueTaskDelete(task);
        syncCoordinator.scheduleSync(reason: 'task_delete');
      },
    );
    return result;
  }

  @override
  Stream<List<TaskWrapperEntity>> observeTasks() {
    final controller = StreamController<List<TaskWrapperEntity>>();
    StreamSubscription<List<db.TasksTableData>>? tasksSubscription;
    StreamSubscription<List<db.SubtasksTableData>>? subTasksSubscription;
    StreamSubscription<List<db.TaskTagsTableData>>? taskTagsSubscription;
    StreamSubscription<List<db.CustomTagsTableData>>? customTagsSubscription;

    List<db.TasksTableData>? tasksSnapshot;
    List<db.SubtasksTableData>? subTasksSnapshot;
    List<db.TaskTagsTableData>? taskTagsSnapshot;
    List<db.CustomTagsTableData>? customTagsSnapshot;

    void emitIfReady() {
      if (tasksSnapshot == null ||
          subTasksSnapshot == null ||
          taskTagsSnapshot == null ||
          customTagsSnapshot == null) {
        return;
      }
      controller.add(
        _buildTaskWrappers(
          tasks: tasksSnapshot!,
          subTasks: subTasksSnapshot!,
          taskTags: taskTagsSnapshot!,
          customTags: customTagsSnapshot!,
        ),
      );
    }

    controller.onListen = () {
      tasksSubscription = localDataSource.observeTasks().listen(
        (tasks) {
          tasksSnapshot = tasks;
          emitIfReady();
        },
        onError: controller.addError,
      );
      subTasksSubscription = subTaskLocalDataSource.observeSubTasks().listen(
        (subTasks) {
          subTasksSnapshot = subTasks;
          emitIfReady();
        },
        onError: controller.addError,
      );
      taskTagsSubscription = tagLocalDataSource.observeTaskTags().listen(
        (taskTags) {
          taskTagsSnapshot = taskTags;
          emitIfReady();
        },
        onError: controller.addError,
      );
      customTagsSubscription = tagLocalDataSource.observeCustomTags().listen(
        (customTags) {
          customTagsSnapshot = customTags;
          emitIfReady();
        },
        onError: controller.addError,
      );
    };

    controller.onCancel = () async {
      await tasksSubscription?.cancel();
      await subTasksSubscription?.cancel();
      await taskTagsSubscription?.cancel();
      await customTagsSubscription?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<TaskWrapperEntity> observeTaskById(int id) {
    final controller = StreamController<TaskWrapperEntity>();
    StreamSubscription<db.TasksTableData>? taskSubscription;
    StreamSubscription<List<db.SubtasksTableData>>? subTasksSubscription;
    StreamSubscription<List<db.TaskTagsTableData>>? taskTagsSubscription;
    StreamSubscription<List<db.CustomTagsTableData>>? customTagsSubscription;

    db.TasksTableData? taskSnapshot;
    List<db.SubtasksTableData>? subTasksSnapshot;
    List<db.TaskTagsTableData>? taskTagsSnapshot;
    List<db.CustomTagsTableData>? customTagsSnapshot;

    void emitIfReady() {
      if (taskSnapshot == null ||
          subTasksSnapshot == null ||
          taskTagsSnapshot == null ||
          customTagsSnapshot == null) {
        return;
      }

      final tagsRows = taskTagsSnapshot!
          .where((row) => row.taskId == id)
          .toList();
      if (tagsRows.length > 1) {
        tagsRows.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      final customTagsById = <int, CustomTagEntity>{
        for (final tag in customTagsSnapshot!) tag.id: tag.toDomain(),
      };

      final tags = <TagEntity>[];
      for (final row in tagsRows) {
        final tag = row.isCustom
            ? customTagsById[row.tagId]
            : _defaultTagsById[row.tagId];
        if (tag != null) {
          tags.add(tag);
        }
      }

      controller.add(
        TaskWrapperEntity(
          task: taskSnapshot!.toDomain(),
          subTasks: subTasksSnapshot!
              .map((subTask) => subTask.toDomain())
              .toList(),
          tags: tags,
        ),
      );
    }

    controller.onListen = () {
      taskSubscription = localDataSource.observeTaskById(id).listen(
        (task) {
          taskSnapshot = task;
          emitIfReady();
        },
        onError: controller.addError,
      );
      subTasksSubscription = subTaskLocalDataSource
          .observeSubTasksByTaskId(id)
          .listen(
        (subTasks) {
          subTasksSnapshot = subTasks;
          emitIfReady();
        },
        onError: controller.addError,
      );
      taskTagsSubscription = tagLocalDataSource.observeTaskTags().listen(
        (taskTags) {
          taskTagsSnapshot = taskTags;
          emitIfReady();
        },
        onError: controller.addError,
      );
      customTagsSubscription = tagLocalDataSource.observeCustomTags().listen(
        (customTags) {
          customTagsSnapshot = customTags;
          emitIfReady();
        },
        onError: controller.addError,
      );
    };

    controller.onCancel = () async {
      await taskSubscription?.cancel();
      await subTasksSubscription?.cancel();
      await taskTagsSubscription?.cancel();
      await customTagsSubscription?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  List<TaskWrapperEntity> _buildTaskWrappers({
    required List<db.TasksTableData> tasks,
    required List<db.SubtasksTableData> subTasks,
    required List<db.TaskTagsTableData> taskTags,
    required List<db.CustomTagsTableData> customTags,
  }) {
    final subTasksByTaskId = <int, List<SubTaskEntity>>{};
    for (final subTask in subTasks) {
      final bucket = subTasksByTaskId.putIfAbsent(
        subTask.taskId,
        () => <SubTaskEntity>[],
      );
      bucket.add(subTask.toDomain());
    }

    final taskTagsByTaskId = <int, List<db.TaskTagsTableData>>{};
    for (final row in taskTags) {
      final bucket = taskTagsByTaskId.putIfAbsent(
        row.taskId,
        () => <db.TaskTagsTableData>[],
      );
      bucket.add(row);
    }

    final customTagsById = <int, CustomTagEntity>{
      for (final tag in customTags) tag.id: tag.toDomain(),
    };

    return tasks.map((task) {
      final tagsRows = taskTagsByTaskId[task.id] ??
          const <db.TaskTagsTableData>[];
      if (tagsRows.length > 1) {
        tagsRows.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      final tags = <TagEntity>[];
      for (final row in tagsRows) {
        final tag = row.isCustom
            ? customTagsById[row.tagId]
            : _defaultTagsById[row.tagId];
        if (tag != null) {
          tags.add(tag);
        }
      }

      return TaskWrapperEntity(
        task: task.toDomain(),
        subTasks: subTasksByTaskId[task.id] ?? const <SubTaskEntity>[],
        tags: tags,
      );
    }).toList();
  }

  Future<void> _enqueueTaskOp({
    required TaskEntity task,
    required String op,
  }) async {
    if (op != 'create' && task.networkId == null && task.clientId == null) {
      TalkerService.instance.warning(
        'syncTag enqueue task op missing ids',
      );
    }
    final opId = _uuid.v4();
    final entry = SyncQueueEntryEntity(
      opId: opId,
      entity: 'task',
      op: op,
      id: task.networkId,
      clientId: task.clientId,
      data: SyncOpDataEntity(
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
      ),
    );
    final result = await syncRepository.enqueueOp(entry);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(
        'syncTag enqueue task op failed',
        failure,
      ),
      ifRight: (_) => TalkerService.instance.info('syncTag enqueue task op ok'),
    );
  }

  Future<void> _enqueueTaskDelete(TaskEntity? task) async {
    if (task?.networkId == null && task?.clientId == null) {
      TalkerService.instance.warning(
        'syncTag enqueue task delete missing ids',
      );
    }
    final entry = SyncQueueEntryEntity(
      opId: _uuid.v4(),
      entity: 'task',
      op: 'delete',
      id: task?.networkId,
      clientId: task?.clientId,
      data: null,
    );
    final result = await syncRepository.enqueueOp(entry);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(
        'syncTag enqueue task delete failed',
        failure,
      ),
      ifRight: (_) =>
          TalkerService.instance.info('syncTag enqueue task delete ok'),
    );
  }
}

