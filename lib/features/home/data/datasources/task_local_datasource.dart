import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/core/services/talker_service.dart';

abstract class TaskLocalDataSource {
  Future<Either<Failure, List<db.TasksTableData>>> getTasks();
  Future<Either<Failure, List<db.TasksTableData>>> getTasksByDate(
    DateTime date,
  );
  Future<Either<Failure, db.TasksTableData>> getTaskById(int id);
  Future<Either<Failure, db.TasksTableData>> createTask(
    db.TasksTableCompanion task,
  );
  Future<Either<Failure, db.TasksTableData>> updateTask(db.TasksTableData task);
  Future<Either<Failure, void>> deleteTask(int id);
  Stream<List<db.TasksTableData>> observeTasks();
  Stream<db.TasksTableData> observeTaskById(int id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final db.AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

  @override
  Future<Either<Failure, List<db.TasksTableData>>> getTasks() async {
    try {
      TalkerService.instance.info('syncTag getTasks start');
      final driftTasks = await (database.select(
        database.tasksTable,
      )..where((task) => task.deletedAt.isNull())).get();
      TalkerService.instance.info(
        'syncTag getTasks result: ${driftTasks.length}',
      );
      return Right(driftTasks);
    } catch (e) {
      TalkerService.instance.error('syncTag getTasks error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.TasksTableData>>> getTasksByDate(
    DateTime date,
  ) async {
    try {
      TalkerService.instance.info('syncTag getTasksByDate start: $date');
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final driftTasks =
          await (database.select(database.tasksTable)..where(
                (task) =>
                    task.date.isBetweenValues(startOfDay, endOfDay) &
                    task.deletedAt.isNull(),
              ))
              .get();

      TalkerService.instance.info(
        'syncTag getTasksByDate result: ${driftTasks.length}',
      );
      return Right(driftTasks);
    } catch (e) {
      TalkerService.instance.error('syncTag getTasksByDate error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> getTaskById(int id) async {
    try {
      TalkerService.instance.info('syncTag getTaskById start: $id');
      final driftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingle();
      TalkerService.instance.info(
        'syncTag getTaskById result: ${driftTask.id}',
      );
      return Right(driftTask);
    } catch (e) {
      TalkerService.instance.error('syncTag getTaskById error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> createTask(
    db.TasksTableCompanion task,
  ) async {
    try {
      TalkerService.instance.info('syncTag createTask start');
      final id = await database.into(database.tasksTable).insert(task);
      final createdDriftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(id))).getSingle();
      TalkerService.instance.info(
        'syncTag createTask result: ${createdDriftTask.id}',
      );
      return Right(createdDriftTask);
    } catch (e) {
      TalkerService.instance.error('syncTag createTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.TasksTableData>> updateTask(
    db.TasksTableData task,
  ) async {
    try {
      TalkerService.instance.info('syncTag updateTask start: ${task.id}');
      final taskCompanion = task.toCompanion(true);
      await database.update(database.tasksTable).replace(taskCompanion);
      final updatedDriftTask = await (database.select(
        database.tasksTable,
      )..where((t) => t.id.equals(task.id))).getSingle();
      TalkerService.instance.info(
        'syncTag updateTask result: ${updatedDriftTask.id}',
      );
      return Right(updatedDriftTask);
    } catch (e) {
      TalkerService.instance.error('syncTag updateTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      TalkerService.instance.info('syncTag deleteTask start: $id');
      await (database.delete(
        database.taskTagsTable,
      )..where((t) => t.taskId.equals(id))).go();
      await (database.update(
        database.tasksTable,
      )..where((t) => t.id.equals(id))).write(
        db.TasksTableCompanion(
          deletedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      TalkerService.instance.info('syncTag deleteTask done: $id');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag deleteTask error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.TasksTableData>> observeTasks() {
    TalkerService.instance.info('syncTag observeTasks start');
    return (database.select(
      database.tasksTable,
    )..where((task) => task.deletedAt.isNull())).watch().map((driftTasks) {
      return driftTasks.toList();
    });
  }

  @override
  Stream<db.TasksTableData> observeTaskById(int id) {
    TalkerService.instance.info('syncTag observeTaskById start: $id');
    return (database.select(database.tasksTable)
          ..where((task) => task.id.equals(id) & task.deletedAt.isNull()))
        .watch()
        .map((driftTask) {
          return driftTask.first;
        });
  }
}
