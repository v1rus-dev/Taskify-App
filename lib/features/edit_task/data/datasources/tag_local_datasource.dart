import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/database/app_database.dart' as db;

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
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final db.AppDatabase _database;

  TagLocalDataSourceImpl(this._database);

  @override
  Future<Either<Failure, List<db.CustomTagsTableData>>> getCustomTags() async {
    try {
      final tags = await _database.select(_database.customTagsTable).get();
      return Right(tags);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.CustomTagsTableData>> createCustomTag(
    db.CustomTagsTableCompanion tag,
  ) async {
    try {
      final id = await _database.into(_database.customTagsTable).insert(tag);
      final created = await (_database.select(_database.customTagsTable)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      return Right(created);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, db.CustomTagsTableData>> updateCustomTag(
    db.CustomTagsTableData tag,
  ) async {
    try {
      await _database.update(_database.customTagsTable).replace(tag);
      final updated = await (_database.select(_database.customTagsTable)
            ..where((t) => t.id.equals(tag.id)))
          .getSingle();
      return Right(updated);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomTag(int id) async {
    try {
      await (_database.delete(_database.customTagsTable)
            ..where((t) => t.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<db.TaskTagsTableData>>> getTaskTagsByTaskId(
    int taskId,
  ) async {
    try {
      final rows = await (_database.select(_database.taskTagsTable)
            ..where((t) => t.taskId.equals(taskId)))
          .get();
      return Right(rows);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replaceTaskTags(
    int taskId,
    List<db.TaskTagsTableCompanion> tags,
  ) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.taskTagsTable)
              ..where((t) => t.taskId.equals(taskId)))
            .go();
        if (tags.isNotEmpty) {
          await _database.batch((batch) {
            batch.insertAll(_database.taskTagsTable, tags);
          });
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
