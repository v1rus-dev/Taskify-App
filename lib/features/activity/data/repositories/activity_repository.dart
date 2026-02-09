import 'package:taskify/features/activity/data/datasources/activity_local_datasource.dart';
import 'package:taskify/features/activity/domain/models/activity_models.dart';

abstract class ActivityRepository {
  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  });

  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  });
}

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this._localDataSource);

  final ActivityLocalDataSource _localDataSource;

  @override
  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  }) {
    return _localDataSource.observeCompletedCountByDate(from: from, to: to);
  }

  @override
  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  }) {
    return _localDataSource.observeTopTagsByCompletedTasks(
      from: from,
      to: to,
      limit: limit,
    );
  }
}
