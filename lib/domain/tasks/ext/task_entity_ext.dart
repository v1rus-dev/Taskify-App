import 'package:intl/intl.dart';
import 'package:taskify/domain/tasks/models/task.dart';

extension TaskEntityExtension on TaskEntity {
  String duration({
    required bool use24Hour,
    required String allDayLabel,
  }) {
    if (isAllDay) {
      return allDayLabel;
    }
    final formatPattern = use24Hour ? 'HH:mm' : 'hh:mm a';
    final timeFormat = DateFormat(formatPattern);
    final localStartTime = startTime?.toLocal();
    final localEndTime = endTime?.toLocal();
    if (localStartTime == null || localEndTime == null) {
      return '';
    }
    return '${timeFormat.format(localStartTime)} - ${timeFormat.format(localEndTime)}';
  }
}
