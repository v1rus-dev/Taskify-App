import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeOfDay(
  BuildContext context,
  TimeOfDay? time,
  bool use24Hour,
) {
  if (time == null) {
    return 'Not set';
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  final dateTime = DateTime(0, 1, 1, time.hour, time.minute);
  if (use24Hour) {
    return DateFormat('HH:mm', locale).format(dateTime);
  }

  final formatted = DateFormat('h:mm a', locale).format(dateTime);
  return formatted.endsWith('.') ? formatted : '$formatted.';
}
