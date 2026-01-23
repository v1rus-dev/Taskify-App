import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/data/mappers/task_mapper.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/repository/task_repository.dart';
import 'package:taskify/domain/sync/models/sync_op_data.dart';
import 'package:taskify/domain/sync/models/sync_queue_entry.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final SyncRepository syncRepository;
  final SyncCoordinator syncCoordinator;
  final Uuid _uuid = const Uuid();

  TaskRepositoryImpl(
    this.localDataSource,
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
  Stream<List<TaskEntity>> observeTasks() {
    return localDataSource.observeTasks().map((tasks) => tasks.map((task) => task.toDomain()).toList());
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
    final entry = SyncQueueEntry(
      opId: opId,
      entity: 'task',
      op: op,
      id: task.networkId,
      clientId: task.clientId,
      data: SyncOpData(
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
    final entry = SyncQueueEntry(
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
