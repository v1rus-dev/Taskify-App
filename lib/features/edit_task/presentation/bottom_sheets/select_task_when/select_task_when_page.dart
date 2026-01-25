import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/domain/tasks/models/task_duration_type.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_when/bloc/select_task_when_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_when/select_task_when_bottom_sheet.dart';

class SelectTaskWhenPage extends StatelessWidget {
  const SelectTaskWhenPage({super.key});

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
    final editState = context.read<EditTaskBloc>().state;
    return BlocProvider(
      create: (_) => SelectTaskWhenBloc(
        selectedDate: editState.selectedDate,
        durationType: _initialDurationType(editState.isAllDay),
        initialStartTime: _initialTimeOfDay(editState.startTime),
        initialEndTime: _initialTimeOfDay(editState.endTime),
      ),
      child: const SelectTaskWhenBottomSheet(),
    );
  }
}
