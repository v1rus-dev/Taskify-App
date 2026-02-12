import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/domain/repositories/tag_repository.dart';

class TagInteractor {
  TagInteractor(this._repository);

  final TagRepository _repository;

  Future<Either<Failure, List<TagEntity>>> getCustomTags() async {
    return _repository.getCustomTags();
  }

  Stream<List<TagEntity>> observeCustomTags() {
    return _repository.observeCustomTags();
  }

  Future<Either<Failure, TagEntity>> createCustomTag(
    CustomTagEntity tag,
  ) async {
    return _repository.createCustomTag(tag);
  }

  Future<Either<Failure, TagEntity>> updateCustomTag(
    CustomTagEntity tag,
  ) async {
    return _repository.updateCustomTag(tag);
  }

  Future<Either<Failure, void>> deleteCustomTag(int id) async {
    return _repository.deleteCustomTag(id);
  }

  Future<Either<Failure, List<TagEntity>>> getTaskTags(int taskId) async {
    return _repository.getTaskTags(taskId);
  }

  Future<Either<Failure, void>> setTaskTags(
    int taskId,
    List<TagEntity> tags,
  ) async {
    return _repository.setTaskTags(taskId, tags);
  }
}

