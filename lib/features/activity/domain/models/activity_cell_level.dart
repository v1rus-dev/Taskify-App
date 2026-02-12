import 'dart:ui';

enum ActivityCellLevel { empty, low, medium, high }

extension ActivityCellLevelExtension on ActivityCellLevel {
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

  Color get color {
    switch (this) {
      case ActivityCellLevel.empty:
        return Color(0xFFF4F4F4);
      case ActivityCellLevel.low:
        return Color(0xFFBBF7D0);
      case ActivityCellLevel.medium:
        return Color(0xFF4DDA80);
      case ActivityCellLevel.high:
        return Color(0xFF22C55E);
    }
  }
}
