import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/entities/tag.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagEntity>>> getCustomTags();
  Future<Either<Failure, TagEntity>> createCustomTag(CustomTagEntity tag);
  Future<Either<Failure, TagEntity>> updateCustomTag(CustomTagEntity tag);
  Future<Either<Failure, void>> deleteCustomTag(int id);
  Future<Either<Failure, List<TagEntity>>> getTaskTags(int taskId);
  Future<Either<Failure, void>> setTaskTags(int taskId, List<TagEntity> tags);
}
