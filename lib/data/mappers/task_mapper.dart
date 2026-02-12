import 'package:drift/drift.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/features/tasks/data/models/task_entity.dart';

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
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
      deletedAt: Value(task.deletedAt),
    );
  }
}
