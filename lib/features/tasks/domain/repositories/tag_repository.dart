import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagEntity>>> getCustomTags();
  Stream<List<TagEntity>> observeCustomTags();
  Future<Either<Failure, TagEntity>> createCustomTag(CustomTagEntity tag);
  Future<Either<Failure, TagEntity>> updateCustomTag(CustomTagEntity tag);
  Future<Either<Failure, void>> deleteCustomTag(int id);
  Future<Either<Failure, List<TagEntity>>> getTaskTags(int taskId);
  Future<Either<Failure, void>> setTaskTags(int taskId, List<TagEntity> tags);
}
