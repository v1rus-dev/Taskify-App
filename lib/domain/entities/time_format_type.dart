enum TimeFormatType {
  hour24,
  hour12,
}

extension TimeFormatTypeX on TimeFormatType {
  bool get is24Hour => this == TimeFormatType.hour24;

  String get label {
    switch (this) {
      case TimeFormatType.hour24:
        return '24-hour';
      case TimeFormatType.hour12:
        return '12-hour';
    }
  }
}

TimeFormatType timeFormatTypeFromBool(bool use24Hour) {
  return use24Hour ? TimeFormatType.hour24 : TimeFormatType.hour12;
}
