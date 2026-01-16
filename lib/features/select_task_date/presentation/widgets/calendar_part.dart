import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'calendar_widget.dart';

class CalendarPart extends ConsumerWidget {
  const CalendarPart({
    super.key,
    required this.selectedDate,
    required this.isAllDay,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CalendarWidget(
      selectedDate: selectedDate,
      isAllDay: isAllDay,
    );
  }
}
