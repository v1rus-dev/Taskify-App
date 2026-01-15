import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';

part 'select_task_state.freezed.dart';

@freezed
abstract class SelectTaskState with _$SelectTaskState {
  const factory SelectTaskState({
    required DateTime selectedDate,
    @Default(TaskDurationType.allDay) TaskDurationType durationType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) = _SelectTaskState;
}
