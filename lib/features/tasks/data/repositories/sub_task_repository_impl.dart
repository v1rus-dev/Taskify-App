import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/features/tasks/data/sources/sub_task_local_datasource.dart';
import 'package:taskify/features/tasks/data/mappers/sub_task_mapper.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/features/tasks/domain/repositories/sub_task_repository.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/domain/sync/models/sync_op_data_entity.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry_entity.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class SubTaskRepositoryImpl implements SubTaskRepository {
  SubTaskRepositoryImpl(
    this._localDataSource,
    this._taskLocalDataSource,
    this._syncRepository,
    this._syncCoordinator,
  );

  final SubTaskLocalDataSource _localDataSource;
  final TaskLocalDataSource _taskLocalDataSource;
  final SyncRepository _syncRepository;
  final SyncCoordinator _syncCoordinator;
  final Uuid _uuid = const Uuid();

  @override
  Future<Either<Failure, List<SubTaskEntity>>> insertSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    final normalized = subTasks
        .map(
          (subTask) => SubTaskEntity(
            id: subTask.id,
            networkId: subTask.networkId,
            taskId: subTask.taskId,
            title: subTask.title,
            isCompleted: subTask.isCompleted,
            deletedAt: subTask.deletedAt,
          ),
        )
        .toList();
    final companions = normalized
        .map((subTask) => subTask.toInsertCompanion())
        .toList();
    final result = await _localDataSource.insertSubTasks(companions);
    Failure? failure;
    List<SubTaskEntity> created = const [];
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) =>
          created = right.map((subtask) => subtask.toDomain()).toList(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    await _enqueueSubTaskCreates(created);
    _syncCoordinator.scheduleSync(reason: 'subtask_create');
    return Right(created);
  }

  @override
  Future<Either<Failure, List<SubTaskEntity>>> updateSubTasks(
    List<SubTaskEntity> subTasks,
  ) async {
    final companions = subTasks
        .map((subTask) => subTask.toUpdateCompanion())
        .toList();
    final result = await _localDataSource.updateSubTasks(companions);
    Failure? failure;
    List<SubTaskEntity> updated = const [];
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (right) =>
          updated = right.map((subtask) => subtask.toDomain()).toList(),
    );
    if (failure != null) {
      return Left(failure!);
    }
    await _enqueueSubTaskUpdates(updated);
    _syncCoordinator.scheduleSync(reason: 'subtask_update');
    return Right(updated);
  }

  @override
  Future<Either<Failure, void>> removeSubTasks(List<int> subTaskIds) async {
    final existing = await _localDataSource.getSubTasksByIds(subTaskIds);
    List<SubTaskEntity> items = const [];
    existing.fold(
      ifLeft: (_) {},
      ifRight: (value) =>
          items = value.map((subtask) => subtask.toDomain()).toList(),
    );
    final result = await _localDataSource.removeSubTasks(subTaskIds);
    await result.fold(
      ifLeft: (_) async {},
      ifRight: (_) async {
        await _enqueueSubTaskDeletes(items);
        _syncCoordinator.scheduleSync(reason: 'subtask_delete');
      },
    );
    return result;
  }

  @override
  Future<Either<Failure, void>> removeSubTask(int subTaskId) async {
    final existing = await _localDataSource.getSubTasksByIds([subTaskId]);
    SubTaskEntity? item;
    existing.fold(
      ifLeft: (_) {},
      ifRight: (value) => item = value.isEmpty ? null : value.first.toDomain(),
    );
    final result = await _localDataSource.removeSubTask(subTaskId);
    await result.fold(
      ifLeft: (_) async {},
      ifRight: (_) async {
        if (item != null) {
          await _enqueueSubTaskDeletes([item!]);
          _syncCoordinator.scheduleSync(reason: 'subtask_delete');
        }
      },
    );
    return result;
  }

  @override
  Future<Either<Failure, List<SubTaskEntity>>> getSubTasksByTaskId(
    int taskId,
  ) async {
    final result = await _localDataSource.getSubTasksByTaskId(taskId);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (subtasks) =>
          Right(subtasks.map((subtask) => subtask.toDomain()).toList()),
    );
  }

  Future<void> _enqueueSubTaskCreates(List<SubTaskEntity> subTasks) async {
    final taskInfo = await _loadTaskInfo(subTasks);
    for (final subTask in subTasks) {
      final task = taskInfo[subTask.taskId];
      if (task == null) {
        TalkerService.instance.warning(
          'syncTag subtask create missing task mapping',
        );
      }
      final entry = SyncQueueEntryEntity(
        opId: _uuid.v4(),
        entity: 'subtask',
        op: 'create',
        id: subTask.networkId,
        data: SyncOpDataEntity(
          text: subTask.title,
          isCompleted: subTask.isCompleted,
          taskId: task?.networkId,
          taskClientId: task?.clientId,
        ),
      );
      await _enqueue(entry);
    }
  }

  Future<void> _enqueueSubTaskUpdates(List<SubTaskEntity> subTasks) async {
    for (final subTask in subTasks) {
      if (subTask.networkId == null) {
        TalkerService.instance.warning('syncTag subtask update missing ids');
      }
      final entry = SyncQueueEntryEntity(
        opId: _uuid.v4(),
        entity: 'subtask',
        op: 'update',
        id: subTask.networkId,
        data: SyncOpDataEntity(text: subTask.title, isCompleted: subTask.isCompleted),
      );
      await _enqueue(entry);
    }
  }

  Future<void> _enqueueSubTaskDeletes(List<SubTaskEntity> subTasks) async {
    for (final subTask in subTasks) {
      if (subTask.networkId == null) {
        TalkerService.instance.warning('syncTag subtask delete missing ids');
      }
      final entry = SyncQueueEntryEntity(
        opId: _uuid.v4(),
        entity: 'subtask',
        op: 'delete',
        id: subTask.networkId,
        data: null,
      );
      await _enqueue(entry);
    }
  }

  Future<void> _enqueue(SyncQueueEntryEntity entry) async {
    final result = await _syncRepository.enqueueOp(entry);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(
        'syncTag enqueue subtask op failed',
        failure,
      ),
      ifRight: (_) =>
          TalkerService.instance.info('syncTag enqueue subtask op ok'),
    );
  }

  Future<Map<int, _TaskSyncInfo>> _loadTaskInfo(
    List<SubTaskEntity> subTasks,
  ) async {
    final result = <int, _TaskSyncInfo>{};
    final taskIds = subTasks.map((item) => item.taskId).toSet().toList();
    for (final taskId in taskIds) {
      final taskResult = await _taskLocalDataSource.getTaskById(taskId);
      taskResult.fold(
        ifLeft: (failure) => TalkerService.instance.error(
          'syncTag load task for subtask failed',
          failure,
        ),
        ifRight: (task) {
          result[taskId] = _TaskSyncInfo(
            networkId: task.networkId,
            clientId: task.clientId,
          );
        },
      );
    }
    return result;
  }

  @override
  Stream<List<SubTaskEntity>> observeSubTasksByTaskId(int taskId) {
    return _localDataSource
        .observeSubTasksByTaskId(taskId)
        .map(
          (subtasks) => subtasks.map((subtask) => subtask.toDomain()).toList(),
        );
  }
}

class _TaskSyncInfo {
  const _TaskSyncInfo({this.networkId, this.clientId});

  final int? networkId;
  final String? clientId;
}
