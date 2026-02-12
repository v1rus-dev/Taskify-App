import 'package:equatable/equatable.dart';
import 'package:taskify/features/activity/domain/models/activity_cell_level.dart';

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