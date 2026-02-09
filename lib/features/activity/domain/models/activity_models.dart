import 'package:equatable/equatable.dart';

enum ActivityCellLevel { empty, low, medium, high }

extension ActivityCellLevelX on ActivityCellLevel {
  static ActivityCellLevel fromCount(int count) {
    if (count <= 0) {
      return ActivityCellLevel.empty;
    }
    if (count <= 2) {
      return ActivityCellLevel.low;
    }
    if (count <= 4) {
      return ActivityCellLevel.medium;
    }
    return ActivityCellLevel.high;
  }
}

enum ActivityStatus { initial, loading, ready, error }

class ActivityHeatmapCell extends Equatable {
  const ActivityHeatmapCell({
    required this.date,
    required this.count,
    required this.level,
  });

  final DateTime date;
  final int count;
  final ActivityCellLevel level;

  @override
  List<Object?> get props => [date, count, level];
}

class ActivityTopTag extends Equatable {
  const ActivityTopTag({
    required this.tagId,
    required this.isCustom,
    required this.title,
    required this.colorValue,
    required this.usageCount,
  });

  final int tagId;
  final bool isCustom;
  final String title;
  final int colorValue;
  final int usageCount;

  @override
  List<Object?> get props => [tagId, isCustom, title, colorValue, usageCount];
}
