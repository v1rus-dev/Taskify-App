import 'package:equatable/equatable.dart';

enum TaskRecurrenceFrequency { daily, weekly, monthly, yearly }

class TaskRecurrence extends Equatable {
  const TaskRecurrence({required this.frequency});

  final TaskRecurrenceFrequency frequency;

  @override
  List<Object?> get props => [frequency];
}
