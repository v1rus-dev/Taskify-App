import 'package:taskify/features/activity/data/repositories/activity_repository.dart';
import 'package:taskify/features/activity/domain/models/activity_models.dart';

class ActivityInteractor {
  ActivityInteractor(this._repository);

  final ActivityRepository _repository;

  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  }) {
    return _repository.observeCompletedCountByDate(from: from, to: to);
  }

  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  }) {
    return _repository.observeTopTagsByCompletedTasks(
      from: from,
      to: to,
      limit: limit,
    );
  }
}
