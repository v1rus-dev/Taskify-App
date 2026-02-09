import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:taskify/features/activity/domain/models/activity_date_utils.dart';
import 'package:taskify/features/activity/domain/models/activity_models.dart';
import 'package:taskify/features/activity/domain/usecases/activity_interactor.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    required this.activityInteractor,
    DateTime Function()? nowProvider,
  }) : super(
         ActivityState.initial(activityDay((nowProvider ?? DateTime.now)())),
       ) {
    on<ActivityStarted>(_onStarted);
    on<ActivityCompletedMapReceived>(_onCompletedMapReceived);
    on<ActivityTopTagsReceived>(_onTopTagsReceived);
    on<ActivityFailed>(_onFailed);
  }

  final ActivityInteractor activityInteractor;

  static const int _gridRows = 7;
  static const int _gridColumns = 17;
  static const int _gridCellsCount = _gridRows * _gridColumns;
  static const Duration _oneDay = Duration(days: 1);

  StreamSubscription<Map<DateTime, int>>? _completedMapSubscription;
  StreamSubscription<List<ActivityTopTag>>? _topTagsSubscription;

  Future<void> _onStarted(
    ActivityStarted event,
    Emitter<ActivityState> emit,
  ) async {
    if (_completedMapSubscription != null || _topTagsSubscription != null) {
      return;
    }

    final rangeEnd = activityDay(state.today);
    final rangeStart = activityDay(
      rangeEnd.subtract(const Duration(days: _gridCellsCount - 1)),
    );

    emit(
      state.copyWith(
        status: ActivityStatus.loading,
        stats: state.stats.copyWith(rangeStart: rangeStart, rangeEnd: rangeEnd),
        errorMessage: '',
      ),
    );

    _completedMapSubscription = activityInteractor
        .observeCompletedCountByDate(from: rangeStart, to: rangeEnd)
        .listen(
          (completedByDate) =>
              add(ActivityCompletedMapReceived(completedByDate)),
          onError: (Object error, StackTrace stackTrace) {
            add(ActivityFailed(error.toString()));
          },
        );

    _topTagsSubscription = activityInteractor
        .observeTopTagsByCompletedTasks(from: rangeStart, to: rangeEnd)
        .listen(
          (topTags) => add(ActivityTopTagsReceived(topTags)),
          onError: (Object error, StackTrace stackTrace) {
            add(ActivityFailed(error.toString()));
          },
        );
  }

  void _onCompletedMapReceived(
    ActivityCompletedMapReceived event,
    Emitter<ActivityState> emit,
  ) {
    final normalizedMap = _normalizeCompletedMap(
      completedByDate: event.completedByDate,
      rangeStart: state.stats.rangeStart,
      rangeEnd: state.stats.rangeEnd,
    );
    final heatmapCells = _buildHeatmapCells(
      completedByDate: normalizedMap,
      rangeStart: state.stats.rangeStart,
    );
    final currentStreak = _calculateCurrentStreak(
      completedByDate: normalizedMap,
      rangeEnd: state.stats.rangeEnd,
    );
    final bestStreak = _calculateBestStreak(
      completedByDate: normalizedMap,
      rangeStart: state.stats.rangeStart,
    );

    emit(
      state.copyWith(
        status: ActivityStatus.ready,
        stats: state.stats.copyWith(
          completedByDate: Map.unmodifiable(normalizedMap),
          heatmapCells: List.unmodifiable(heatmapCells),
          hasAnyCompletedTasks: normalizedMap.isNotEmpty,
        ),
        streak: state.streak.copyWith(
          currentStreak: currentStreak,
          bestStreak: bestStreak,
        ),
        errorMessage: '',
      ),
    );
  }

  void _onTopTagsReceived(
    ActivityTopTagsReceived event,
    Emitter<ActivityState> emit,
  ) {
    emit(
      state.copyWith(
        status: ActivityStatus.ready,
        tags: state.tags.copyWith(topTags: List.unmodifiable(event.topTags)),
        errorMessage: '',
      ),
    );
  }

  void _onFailed(ActivityFailed event, Emitter<ActivityState> emit) {
    emit(
      state.copyWith(status: ActivityStatus.error, errorMessage: event.message),
    );
  }

  Map<DateTime, int> _normalizeCompletedMap({
    required Map<DateTime, int> completedByDate,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    final normalized = <DateTime, int>{};
    for (final entry in completedByDate.entries) {
      final day = activityDay(entry.key);
      if (day.isBefore(rangeStart) || day.isAfter(rangeEnd)) {
        continue;
      }
      if (entry.value <= 0) {
        continue;
      }
      normalized[day] = (normalized[day] ?? 0) + entry.value;
    }
    return normalized;
  }

  List<ActivityHeatmapCell> _buildHeatmapCells({
    required Map<DateTime, int> completedByDate,
    required DateTime rangeStart,
  }) {
    final cells = <ActivityHeatmapCell>[];
    for (var i = 0; i < _gridCellsCount; i++) {
      final date = activityDay(rangeStart.add(Duration(days: i)));
      final count = completedByDate[date] ?? 0;
      cells.add(
        ActivityHeatmapCell(
          date: date,
          count: count,
          level: ActivityCellLevelX.fromCount(count),
        ),
      );
    }
    return cells;
  }

  int _calculateCurrentStreak({
    required Map<DateTime, int> completedByDate,
    required DateTime rangeEnd,
  }) {
    var streak = 0;
    var day = activityDay(rangeEnd);
    while ((completedByDate[day] ?? 0) > 0) {
      streak++;
      day = activityDay(day.subtract(_oneDay));
    }
    return streak;
  }

  int _calculateBestStreak({
    required Map<DateTime, int> completedByDate,
    required DateTime rangeStart,
  }) {
    var best = 0;
    var current = 0;
    for (var i = 0; i < _gridCellsCount; i++) {
      final day = activityDay(rangeStart.add(Duration(days: i)));
      if ((completedByDate[day] ?? 0) > 0) {
        current++;
        if (current > best) {
          best = current;
        }
      } else {
        current = 0;
      }
    }
    return best;
  }

  @override
  Future<void> close() async {
    await _completedMapSubscription?.cancel();
    await _topTagsSubscription?.cancel();
    return super.close();
  }
}
