import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/tasks/models/task_duration_type.dart';

part 'select_task_when_event.dart';
part 'select_task_when_state.dart';
part 'select_task_when_bloc.freezed.dart';

class SelectTaskWhenBloc extends Bloc<SelectTaskWhenEvent, SelectTaskWhenState> {
  static const _defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const _defaultEndTime = TimeOfDay(hour: 10, minute: 0);

  SelectTaskWhenBloc({
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
    on<_SelectionCleared>(_onSelectionCleared);
  }

  static SelectTaskWhenState _buildInitialState({
    required DateTime? selectedDate,
    required TaskDurationType? durationType,
    required TimeOfDay? initialStartTime,
    required TimeOfDay? initialEndTime,
  }) {
    final fallbackDefaults = DateSelection.defaultNow();
    final resolvedDurationType = durationType ?? fallbackDefaults.durationType;
    final isPeriod = resolvedDurationType == TaskDurationType.period;

    final current = DateSelection(
      selectedDate: selectedDate ?? fallbackDefaults.selectedDate,
      durationType: resolvedDurationType,
      startTime: isPeriod ? initialStartTime ?? _defaultStartTime : null,
      endTime: isPeriod ? initialEndTime ?? _defaultEndTime : null,
    );

    return SelectTaskWhenState(defaults: current, current: current);
  }

  void _onDateSelected(
    _DateSelected event,
    Emitter<SelectTaskWhenState> emit,
  ) {
    emit(
      state.copyWith(
        current: state.current.copyWith(selectedDate: event.date),
      ),
    );
  }

  void _onDurationTypeSelected(
    _DurationTypeSelected event,
    Emitter<SelectTaskWhenState> emit,
  ) {
    emit(
      state.copyWith(
        current: state.current.copyWith(
          durationType: event.type,
          startTime:
              event.type == TaskDurationType.allDay ? null : _defaultStartTime,
          endTime:
              event.type == TaskDurationType.allDay ? null : _defaultEndTime,
        ),
      ),
    );
  }

  void _onStartTimeSelected(
    _StartTimeSelected event,
    Emitter<SelectTaskWhenState> emit,
  ) {
    emit(
      state.copyWith(
        current: state.current.copyWith(startTime: event.time),
      ),
    );
  }

  void _onEndTimeSelected(
    _EndTimeSelected event,
    Emitter<SelectTaskWhenState> emit,
  ) {
    emit(
      state.copyWith(
        current: state.current.copyWith(endTime: event.time),
      ),
    );
  }

  void _onSelectionCleared(
    _SelectionCleared event,
    Emitter<SelectTaskWhenState> emit,
  ) {
    emit(
      state.copyWith(
        current: state.defaults,
      ),
    );
  }
}
