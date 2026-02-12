import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:taskify/features/activity/data/repositories/activity_repository.dart';
import 'package:taskify/features/activity/domain/models/activity_top_tag.dart';
import 'package:taskify/features/activity/domain/usecases/activity_interactor.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';

class _FakeActivityRepository implements ActivityRepository {
  _FakeActivityRepository({
    required this.completedStream,
    required this.topTagsStream,
  });

  final Stream<Map<DateTime, int>> completedStream;
  final Stream<List<ActivityTopTag>> topTagsStream;

  @override
  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  }) {
    return completedStream;
  }

  @override
  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  }) {
    return topTagsStream;
  }
}

void main() {
  group('ActivityBloc Date Normalization', () {
    late StreamController<Map<DateTime, int>> completedController;
    late StreamController<List<ActivityTopTag>> topTagsController;
    late ActivityBloc bloc;

    setUp(() {
      completedController = StreamController<Map<DateTime, int>>.broadcast();
      topTagsController = StreamController<List<ActivityTopTag>>.broadcast();
      final repository = _FakeActivityRepository(
        completedStream: completedController.stream,
        topTagsStream: topTagsController.stream,
      );
      bloc = ActivityBloc(
        activityInteractor: ActivityInteractor(repository),
        nowProvider: () => DateTime(2026, 2, 9, 14, 30),
      )..add(const ActivityStarted());
    });

    tearDown(() async {
      await bloc.close();
      await completedController.close();
      await topTagsController.close();
    });

    test('normalizes map keys and merges duplicates of same day', () async {
      completedController.add({
        DateTime(2026, 2, 9, 1, 10): 1,
        DateTime(2026, 2, 9, 22, 20): 2,
      });
      topTagsController.add(const []);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final day = DateTime(2026, 2, 9);
      expect(bloc.state.stats.completedByDate.length, 1);
      expect(bloc.state.stats.completedByDate[day], 3);
      expect(bloc.state.stats.heatmapCells.length, 119);
      for (final key in bloc.state.stats.completedByDate.keys) {
        expect(key.hour, 0);
        expect(key.minute, 0);
        expect(key.second, 0);
        expect(key.millisecond, 0);
      }
    });

    test('lookup works only with normalized DateTime key', () async {
      completedController.add({DateTime(2026, 2, 8, 19, 45): 4});
      topTagsController.add(const []);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.stats.completedByDate[DateTime(2026, 2, 8)], 4);
      expect(bloc.state.stats.completedByDate[DateTime(2026, 2, 8, 1)], isNull);
    });
  });
}
