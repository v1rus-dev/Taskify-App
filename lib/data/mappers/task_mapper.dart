import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/domain/entities/task.dart';

extension TaskDbMapper on db.TasksTableData {
  TaskEntity toDomain() {
    return TaskEntity(
      id: id,
      networkId: networkId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      date: date,
      startTime: startTime,
      isAllDay: isAllDay,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class TaskDomainMapper {
  const TaskDomainMapper._();

  static db.TasksTableData fromDomain(TaskEntity task) {
    return db.TasksTableData(
      id: task.id ?? 0,
      networkId: task.networkId,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      date: task.date,
      startTime: task.startTime,
      isAllDay: task.isAllDay,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  static db.TasksTableCompanion toInsertCompanion(TaskEntity task) {
    return db.TasksTableCompanion(
      id: const Value.absent(),
      networkId: Value(task.networkId),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      date: Value(task.date),
      startTime: Value(task.startTime),
      isAllDay: Value(task.isAllDay),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
    );
  }
}
