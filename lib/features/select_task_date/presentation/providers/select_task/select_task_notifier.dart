import 'package:flutter/material.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';
import 'package:taskify/features/select_task_date/presentation/providers/select_task/select_task_state.dart';

// final selectTaskNotifierProvider = NotifierProvider.autoDispose.family<
//   SelectTaskNotifier,
//   SelectTaskState,
//   (DateTime?, TaskDurationType?, TimeOfDay?, TimeOfDay?)
// >(
//   (params) => SelectTaskNotifier(
//     selectedDate: params.$1,
//     durationType: params.$2,
//     initialStartTime: params.$3,
//     initialEndTime: params.$4,
//   ),
// );

// class SelectTaskNotifier extends Notifier<SelectTaskState> {
//   SelectTaskNotifier({
//     required this.selectedDate,
//     required this.durationType,
//     required this.initialStartTime,
//     required this.initialEndTime,
//   }) : super();

//   final DateTime? selectedDate;
//   final TaskDurationType? durationType;
//   final TimeOfDay? initialStartTime;
//   final TimeOfDay? initialEndTime;

//   @override
//   SelectTaskState build() {
//     final resolvedDurationType = durationType ?? TaskDurationType.allDay;
//     final isPeriod = resolvedDurationType == TaskDurationType.period;
//     final defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
//     final defaultEndTime = const TimeOfDay(hour: 10, minute: 0);

//     return SelectTaskState(
//       selectedDate: selectedDate ?? DateTime.now(),
//       durationType: resolvedDurationType,
//       startTime: isPeriod
//           ? initialStartTime ?? defaultStartTime
//           : null,
//       endTime: isPeriod
//           ? initialEndTime ?? defaultEndTime
//           : null,
//     );
//   }

//   void selectDate(DateTime date) {
//     state = state.copyWith(selectedDate: date);
//   }

//   void selectDurationType(TaskDurationType type) {
//     final defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
//     final defaultEndTime = const TimeOfDay(hour: 10, minute: 0);
//     state = state.copyWith(
//       durationType: type,
//       startTime: type == TaskDurationType.allDay ? null : defaultStartTime,
//       endTime: type == TaskDurationType.allDay ? null : defaultEndTime,
//     );
//   }

//   void selectStartTime(TimeOfDay time) {
//     state = state.copyWith(startTime: time);
//   }

//   void selectEndTime(TimeOfDay time) {
//     state = state.copyWith(endTime: time);
//   }
// }
