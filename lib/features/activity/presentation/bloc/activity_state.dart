part of 'activity_bloc.dart';

class StatsInfo extends Equatable {
  const StatsInfo({
    required this.rangeStart,
    required this.rangeEnd,
    required this.completedByDate,
    required this.heatmapCells,
    required this.hasAnyCompletedTasks,
  });

  factory StatsInfo.initial(DateTime today) {
    final day = activityDay(today);
    return StatsInfo(
      rangeStart: day,
      rangeEnd: day,
      completedByDate: const {},
      heatmapCells: const [],
      hasAnyCompletedTasks: false,
    );
  }

  final DateTime rangeStart;
  final DateTime rangeEnd;
  final Map<DateTime, int> completedByDate;
  final List<ActivityHeatmapCell> heatmapCells;
  final bool hasAnyCompletedTasks;

  StatsInfo copyWith({
    DateTime? rangeStart,
    DateTime? rangeEnd,
    Map<DateTime, int>? completedByDate,
    List<ActivityHeatmapCell>? heatmapCells,
    bool? hasAnyCompletedTasks,
  }) {
    return StatsInfo(
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
      completedByDate: completedByDate ?? this.completedByDate,
      heatmapCells: heatmapCells ?? this.heatmapCells,
      hasAnyCompletedTasks: hasAnyCompletedTasks ?? this.hasAnyCompletedTasks,
    );
  }

  @override
  List<Object?> get props => [
    rangeStart,
    rangeEnd,
    completedByDate,
    heatmapCells,
    hasAnyCompletedTasks,
  ];
}

class StreakInfo extends Equatable {
  const StreakInfo({required this.currentStreak, required this.bestStreak});

  const StreakInfo.initial() : currentStreak = 0, bestStreak = 0;

  final int currentStreak;
  final int bestStreak;

  StreakInfo copyWith({int? currentStreak, int? bestStreak}) {
    return StreakInfo(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  @override
  List<Object?> get props => [currentStreak, bestStreak];
}

class TagsInfo extends Equatable {
  const TagsInfo({required this.topTags});

  const TagsInfo.initial() : topTags = const [];

  final List<ActivityTopTag> topTags;

  TagsInfo copyWith({List<ActivityTopTag>? topTags}) {
    return TagsInfo(topTags: topTags ?? this.topTags);
  }

  @override
  List<Object?> get props => [topTags];
}

class ActivityState extends Equatable {
  const ActivityState({
    required this.today,
    required this.stats,
    required this.streak,
    required this.tags,
  });

  factory ActivityState.initial(DateTime today) {
    final normalizedToday = activityDay(today);
    return ActivityState(
      today: normalizedToday,
      stats: StatsInfo.initial(normalizedToday),
      streak: const StreakInfo.initial(),
      tags: const TagsInfo.initial(),
    );
  }

  final DateTime today;
  final StatsInfo stats;
  final StreakInfo streak;
  final TagsInfo tags;

  ActivityState copyWith({
    DateTime? today,
    StatsInfo? stats,
    StreakInfo? streak,
    TagsInfo? tags,
  }) {
    return ActivityState(
      today: today ?? this.today,
      stats: stats ?? this.stats,
      streak: streak ?? this.streak,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [today, stats, streak, tags];
}
