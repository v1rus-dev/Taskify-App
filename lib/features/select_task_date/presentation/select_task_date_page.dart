import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';
import 'package:taskify/features/select_task_date/presentation/bloc/select_task_date_bloc.dart';
import 'package:taskify/features/select_task_date/presentation/select_task_date_bottom_sheet.dart';

class SelectTaskDatePage extends StatelessWidget {
  const SelectTaskDatePage({
    super.key,
    this.selectedDate,
    this.isAllDay,
    this.startTime,
    this.endTime,
    this.onSave,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;
  final void Function(
    DateTime selectedDate,
    bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  )?
  onSave;

  TaskDurationType _initialDurationType(bool? isAllDay) {
    return (isAllDay ?? true)
        ? TaskDurationType.allDay
        : TaskDurationType.period;
  }

  TimeOfDay? _initialTimeOfDay(DateTime? time) {
    if (time == null) {
      return null;
    }
    return TimeOfDay.fromDateTime(time);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectTaskDateBloc(
        selectedDate: selectedDate,
        durationType: _initialDurationType(isAllDay),
        initialStartTime: _initialTimeOfDay(startTime),
        initialEndTime: _initialTimeOfDay(endTime),
      ),
      child: SelectTaskDateBottomSheet(
        selectedDate: selectedDate,
        isAllDay: isAllDay,
        startTime: startTime,
        endTime: endTime,
        onSave: onSave,
      ),
    );
  }
}
