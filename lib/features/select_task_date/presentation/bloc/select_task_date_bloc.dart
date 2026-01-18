import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';

part 'select_task_date_event.dart';
part 'select_task_date_state.dart';
part 'select_task_date_bloc.freezed.dart';

class SelectTaskDateBloc extends Bloc<SelectTaskDateEvent, SelectTaskDateState> {
  SelectTaskDateBloc({
    required DateTime? selectedDate,
    required TaskDurationType? durationType,
    required TimeOfDay? initialStartTime,
    required TimeOfDay? initialEndTime,
  }) : super(
          _buildInitialState(
            selectedDate: selectedDate,
            durationType: durationType,
            initialStartTime: initialStartTime,
            initialEndTime: initialEndTime,
          ),
        ) {
    on<_DateSelected>(_onDateSelected);
    on<_DurationTypeSelected>(_onDurationTypeSelected);
    on<_StartTimeSelected>(_onStartTimeSelected);
    on<_EndTimeSelected>(_onEndTimeSelected);
  }

  static SelectTaskDateState _buildInitialState({
    required DateTime? selectedDate,
    required TaskDurationType? durationType,
    required TimeOfDay? initialStartTime,
    required TimeOfDay? initialEndTime,
  }) {
    final resolvedDurationType = durationType ?? TaskDurationType.allDay;
    final isPeriod = resolvedDurationType == TaskDurationType.period;
    final defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
    final defaultEndTime = const TimeOfDay(hour: 10, minute: 0);

    return SelectTaskDateState(
      selectedDate: selectedDate ?? DateTime.now(),
      durationType: resolvedDurationType,
      startTime: isPeriod ? initialStartTime ?? defaultStartTime : null,
      endTime: isPeriod ? initialEndTime ?? defaultEndTime : null,
    );
  }

  void _onDateSelected(
    _DateSelected event,
    Emitter<SelectTaskDateState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onDurationTypeSelected(
    _DurationTypeSelected event,
    Emitter<SelectTaskDateState> emit,
  ) {
    final defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
    final defaultEndTime = const TimeOfDay(hour: 10, minute: 0);

    emit(
      state.copyWith(
        durationType: event.type,
        startTime:
            event.type == TaskDurationType.allDay ? null : defaultStartTime,
        endTime: event.type == TaskDurationType.allDay ? null : defaultEndTime,
      ),
    );
  }

  void _onStartTimeSelected(
    _StartTimeSelected event,
    Emitter<SelectTaskDateState> emit,
  ) {
    emit(state.copyWith(startTime: event.time));
  }

  void _onEndTimeSelected(
    _EndTimeSelected event,
    Emitter<SelectTaskDateState> emit,
  ) {
    emit(state.copyWith(endTime: event.time));
  }
}
