import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    super.id,
    super.networkId,
    required super.title,
    super.description,
    super.isCompleted,
    required super.date,
    super.startTime,
    super.isAllDay,
    required super.createdAt,
    super.updatedAt,
  });
  
  factory TaskModel.fromDatabase(db.Task task) {
    return TaskModel(
      id: task.id,
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

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
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

  db.TasksCompanion toDatabaseInsert() {
    return db.TasksCompanion.insert(
      networkId: Value(networkId),
      title: title,
      description: Value(description),
      isCompleted: Value(isCompleted),
      date: date,
      startTime: Value(startTime),
      isAllDay: Value(isAllDay),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  db.TasksCompanion toDatabaseUpdate() {
    return db.TasksCompanion(
      id: Value(id!),
      networkId: Value(networkId),
      title: Value(title),
      description: Value(description),
      isCompleted: Value(isCompleted),
      date: Value(date),
      startTime: Value(startTime),
      isAllDay: Value(isAllDay),
      createdAt: Value(createdAt),
      updatedAt: Value(DateTime.now()),
    );
  }
}
