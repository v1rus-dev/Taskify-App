import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/core/services/talker_service.dart';

abstract class TagLocalDataSource {
  Future<Either<Failure, List<db.CustomTagsTableData>>> getCustomTags();
  Future<Either<Failure, db.CustomTagsTableData>> createCustomTag(
    db.CustomTagsTableCompanion tag,
  );
  Future<Either<Failure, db.CustomTagsTableData>> updateCustomTag(
    db.CustomTagsTableData tag,
  );
  Future<Either<Failure, void>> deleteCustomTag(int id);
  Future<Either<Failure, List<db.TaskTagsTableData>>> getTaskTagsByTaskId(
    int taskId,
  );
  Future<Either<Failure, void>> replaceTaskTags(
    int taskId,
    List<db.TaskTagsTableCompanion> tags,
  );
  Stream<List<db.CustomTagsTableData>> observeCustomTags();
  Stream<List<db.TaskTagsTableData>> observeTaskTags();
  Stream<db.TaskTagsTableData> observeTaskTagsByTaskId(int taskId);
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final db.AppDatabase _database;

  TagLocalDataSourceImpl(this._database);

  @override
  Future<Either<Failure, List<db.CustomTagsTableData>>> getCustomTags() async {
    try {
      TalkerService.instance.info('syncTag getCustomTags start');
      final tags = await _database.select(_database.customTagsTable).get();
      TalkerService.instance.info(
        'syncTag getCustomTags result: ${tags.length}',
      );
      return Right(tags);
    } catch (e) {
      TalkerService.instance.error('syncTag getCustomTags error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.CustomTagsTableData>> createCustomTag(
    db.CustomTagsTableCompanion tag,
  ) async {
    try {
      TalkerService.instance.info('syncTag createCustomTag start');
      final id = await _database.into(_database.customTagsTable).insert(tag);
      final created = await (_database.select(
        _database.customTagsTable,
      )..where((t) => t.id.equals(id))).getSingle();
      TalkerService.instance.info(
        'syncTag createCustomTag result: ${created.id}',
      );
      return Right(created);
    } catch (e) {
      TalkerService.instance.error('syncTag createCustomTag error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.CustomTagsTableData>> updateCustomTag(
    db.CustomTagsTableData tag,
  ) async {
    try {
      TalkerService.instance.info('syncTag updateCustomTag start: ${tag.id}');
      await _database.update(_database.customTagsTable).replace(tag);
      final updated = await (_database.select(
        _database.customTagsTable,
      )..where((t) => t.id.equals(tag.id))).getSingle();
      TalkerService.instance.info(
        'syncTag updateCustomTag result: ${updated.id}',
      );
      return Right(updated);
    } catch (e) {
      TalkerService.instance.error('syncTag updateCustomTag error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomTag(int id) async {
    try {
      TalkerService.instance.info('syncTag deleteCustomTag start: $id');
      await (_database.delete(
        _database.customTagsTable,
      )..where((t) => t.id.equals(id))).go();
      TalkerService.instance.info('syncTag deleteCustomTag done: $id');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag deleteCustomTag error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.TaskTagsTableData>>> getTaskTagsByTaskId(
    int taskId,
  ) async {
    try {
      TalkerService.instance.info('syncTag getTaskTagsByTaskId start: $taskId');
      final rows = await (_database.select(
        _database.taskTagsTable,
      )..where((t) => t.taskId.equals(taskId))).get();
      TalkerService.instance.info(
        'syncTag getTaskTagsByTaskId result: ${rows.length}',
      );
      return Right(rows);
    } catch (e) {
      TalkerService.instance.error('syncTag getTaskTagsByTaskId error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceTaskTags(
    int taskId,
    List<db.TaskTagsTableCompanion> tags,
  ) async {
    try {
      TalkerService.instance.info(
        'syncTag replaceTaskTags start: $taskId, ${tags.length}',
      );
      await _database.transaction(() async {
        await (_database.delete(
          _database.taskTagsTable,
        )..where((t) => t.taskId.equals(taskId))).go();
        if (tags.isNotEmpty) {
          await _database.batch((batch) {
            batch.insertAll(_database.taskTagsTable, tags);
          });
        }
      });
      TalkerService.instance.info('syncTag replaceTaskTags done: $taskId');
      return const Right(null);
    } catch (e) {
      TalkerService.instance.error('syncTag replaceTaskTags error', e);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<db.CustomTagsTableData>> observeCustomTags() {
    TalkerService.instance.info('syncTag observeCustomTags start');
    return _database.select(_database.customTagsTable).watch().map((driftTags) {
      return driftTags.toList();
    });
  }

  @override
  Stream<List<db.TaskTagsTableData>> observeTaskTags() {
    TalkerService.instance.info('syncTag observeTaskTags start');
    return _database.select(_database.taskTagsTable).watch().map((driftTags) {
      return driftTags.toList();
    });
  }

  @override
  Stream<db.TaskTagsTableData> observeTaskTagsByTaskId(int taskId) {
    TalkerService.instance.info(
      'syncTag observeTaskTagsByTaskId start: $taskId',
    );
    return (_database.select(
      _database.taskTagsTable,
    )..where((t) => t.taskId.equals(taskId))).watch().map((driftTags) {
      return driftTags.toList().first;
    });
  }
}
