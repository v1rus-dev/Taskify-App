import 'package:equatable/equatable.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';

class EditTaskSnapshot extends Equatable {
  const EditTaskSnapshot({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
  });

  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;

  factory EditTaskSnapshot.fromTask(TaskEntity task) {
    return EditTaskSnapshot(
      title: task.title,
      description: task.description ?? '',
      isCompleted: task.isCompleted,
      date: task.date,
      startTime: task.startTime,
      endTime: task.endTime,
      isAllDay: task.isAllDay,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        isCompleted,
        date,
        startTime,
        endTime,
        isAllDay,
      ];
}

class SubTaskSnapshot extends Equatable {
  const SubTaskSnapshot({
    required this.id,
    required this.localKey,
    required this.title,
    required this.isCompleted,
  });

  final int? id;
  final int localKey;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, localKey, title, isCompleted];
}

class DateSelectionSnapshot extends Equatable {
  const DateSelectionSnapshot({
    required this.selectedDate,
    required this.isAllDay,
    this.startTime,
    this.endTime,
  });

  final DateTime selectedDate;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;

  @override
  List<Object?> get props => [selectedDate, isAllDay, startTime, endTime];
}
