import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/mappers/tag_mapper.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/domain/tags/models/default_tag.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/domain/tags/repository/tag_repository.dart';
import 'package:taskify/features/edit_task/data/datasources/tag_local_datasource.dart';

class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl(this._localDataSource);

  final TagLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<TagEntity>>> getCustomTags() async {
    final result = await _localDataSource.getCustomTags();
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (tags) => Right(tags.map((tag) => tag.toDomain()).toList()),
    );
  }

  @override
  Stream<List<TagEntity>> observeCustomTags() {
    return _localDataSource.observeCustomTags().map(
          (tags) => tags.map((tag) => tag.toDomain()).toList(),
        );
  }

  @override
  Future<Either<Failure, TagEntity>> createCustomTag(CustomTagEntity tag) async {
    final result =
        await _localDataSource.createCustomTag(tag.toInsertCompanion());
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (created) => Right(created.toDomain()),
    );
  }

  @override
  Future<Either<Failure, TagEntity>> updateCustomTag(CustomTagEntity tag) async {
    final result = await _localDataSource.updateCustomTag(
      db.CustomTagsTableData(
        id: tag.id,
        title: tag.title,
        colorValue: tag.color.toARGB32(),
        createdAt: DateTime.now(),
      ),
    );
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (updated) => Right(updated.toDomain()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteCustomTag(int id) async {
    return _localDataSource.deleteCustomTag(id);
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTaskTags(int taskId) async {
    final taskTagsResult = await _localDataSource.getTaskTagsByTaskId(taskId);
    Failure? taskTagsFailure;
    List<db.TaskTagsTableData> rows = const [];
    taskTagsResult.fold(
      ifLeft: (failure) => taskTagsFailure = failure,
      ifRight: (items) => rows = items,
    );
    if (taskTagsFailure != null) {
      return Left(taskTagsFailure!);
    }
    final defaultTags = _resolveDefaultTags(rows);
    final customTags = await _resolveCustomTags(rows);
    return Right([...defaultTags, ...customTags]);
  }

  @override
  Future<Either<Failure, void>> setTaskTags(
    int taskId,
    List<TagEntity> tags,
  ) async {
    final companions = tags
        .map(
          (tag) => db.TaskTagsTableCompanion(
            taskId: Value(taskId),
            tagId: Value(tag.id),
            isCustom: Value(tag.isCustom),
          ),
        )
        .toList(growable: false);
    return _localDataSource.replaceTaskTags(taskId, companions);
  }

  Future<List<TagEntity>> _loadCustomTagsByIds(List<int> ids) async {
    if (ids.isEmpty) {
      return const [];
    }
    final result = await _localDataSource.getCustomTags();
    List<db.CustomTagsTableData> rows = const [];
    result.fold(
      ifLeft: (_) => rows = const [],
      ifRight: (items) => rows = items,
    );
    final filtered = rows.where((tag) => ids.contains(tag.id)).toList();
    return filtered.map((tag) => tag.toDomain()).toList();
  }

  List<TagEntity> _resolveDefaultTags(List<db.TaskTagsTableData> rows) {
    return rows
        .where((row) => !row.isCustom)
        .map((row) => DefaultTagExtension.fromId(row.tagId))
        .whereType<DefaultTag>()
        .map(
          (tag) => DefaultTagEntity(
            defaultTag: tag,
          ),
        )
        .toList();
  }

  Future<List<TagEntity>> _resolveCustomTags(
    List<db.TaskTagsTableData> rows,
  ) async {
    final customTagIds =
        rows.where((row) => row.isCustom).map((row) => row.tagId).toList();
    return _loadCustomTagsByIds(customTagIds);
  }
}
