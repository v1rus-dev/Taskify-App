import 'package:drift/drift.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/data/models/task_recurrence.dart';
import 'package:taskify/features/tasks/data/models/task_reminder.dart';

extension TaskDbMapper on db.TasksTableData {
  TaskEntity toDomain() {
    return TaskEntity(
      id: id,
      networkId: networkId,
      clientId: clientId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      date: date,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
      recurrence: _taskRecurrenceFromDb(recurrenceFrequency),
      reminder: _taskReminderFromDb(reminderType),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

class TaskDomainMapper {
  const TaskDomainMapper._();

  static db.TasksTableData fromDomain(TaskEntity task) {
    return db.TasksTableData(
      id: task.id ?? 0,
      networkId: task.networkId,
      clientId: task.clientId,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      date: task.date,
      startTime: task.startTime,
      endTime: task.endTime,
      isAllDay: task.isAllDay,
      recurrenceFrequency: _taskRecurrenceToDb(task.recurrence),
      reminderType: _taskReminderToDb(task.reminder),
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: task.deletedAt,
    );
  }

  static db.TasksTableCompanion toInsertCompanion(TaskEntity task) {
    return db.TasksTableCompanion(
      id: const Value.absent(),
      networkId: Value(task.networkId),
      clientId: Value(task.clientId),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      date: Value(task.date),
      startTime: Value(task.startTime),
      endTime: Value(task.endTime),
      isAllDay: Value(task.isAllDay),
      recurrenceFrequency: Value(_taskRecurrenceToDb(task.recurrence)),
      reminderType: Value(_taskReminderToDb(task.reminder)),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
      deletedAt: Value(task.deletedAt),
    );
  }
}

TaskRecurrence? _taskRecurrenceFromDb(String? value) {
  return switch (value) {
    'daily' => const TaskRecurrence(frequency: TaskRecurrenceFrequency.daily),
    'weekly' => const TaskRecurrence(frequency: TaskRecurrenceFrequency.weekly),
    'monthly' => const TaskRecurrence(
      frequency: TaskRecurrenceFrequency.monthly,
    ),
    'yearly' => const TaskRecurrence(frequency: TaskRecurrenceFrequency.yearly),
    _ => null,
  };
}

String? _taskRecurrenceToDb(TaskRecurrence? recurrence) {
  return switch (recurrence?.frequency) {
    TaskRecurrenceFrequency.daily => 'daily',
    TaskRecurrenceFrequency.weekly => 'weekly',
    TaskRecurrenceFrequency.monthly => 'monthly',
    TaskRecurrenceFrequency.yearly => 'yearly',
    null => null,
  };
}

TaskReminder? _taskReminderFromDb(String? value) {
  return switch (value) {
    'at_time' => const TaskReminder(type: TaskReminderType.atTime),
    '5m_before' => const TaskReminder(type: TaskReminderType.fiveMinutesBefore),
    '10m_before' => const TaskReminder(type: TaskReminderType.tenMinutesBefore),
    '15m_before' => const TaskReminder(
      type: TaskReminderType.fifteenMinutesBefore,
    ),
    '30m_before' => const TaskReminder(
      type: TaskReminderType.thirtyMinutesBefore,
    ),
    '1h_before' => const TaskReminder(type: TaskReminderType.oneHourBefore),
    '1d_before' => const TaskReminder(type: TaskReminderType.oneDayBefore),
    _ => null,
  };
}

String? _taskReminderToDb(TaskReminder? reminder) {
  return switch (reminder?.type) {
    TaskReminderType.atTime => 'at_time',
    TaskReminderType.fiveMinutesBefore => '5m_before',
    TaskReminderType.tenMinutesBefore => '10m_before',
    TaskReminderType.fifteenMinutesBefore => '15m_before',
    TaskReminderType.thirtyMinutesBefore => '30m_before',
    TaskReminderType.oneHourBefore => '1h_before',
    TaskReminderType.oneDayBefore => '1d_before',
    null => null,
  };
}
