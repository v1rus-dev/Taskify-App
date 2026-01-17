import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/edit_task/domain/entities/sub_task.dart';

extension SubtasksTableDataMapper on SubtasksTableData {
  SubTaskEntity toDomain() {
    return SubTaskEntity(
      id: id,
      networkId: networkId,
      taskId: taskId,
      title: title,
      isCompleted: isCompleted,
    );
  }
}

extension SubTaskEntityCompanionMapper on SubTaskEntity {
  SubtasksTableCompanion toInsertCompanion() {
    return SubtasksTableCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      networkId: Value(networkId),
      taskId: Value(taskId),
      title: Value(title),
      isCompleted: Value(isCompleted),
    );
  }

  SubtasksTableCompanion toUpdateCompanion() {
    return SubtasksTableCompanion(
      id: Value(id!),
      networkId: Value(networkId),
      taskId: Value(taskId),
      title: Value(title),
      isCompleted: Value(isCompleted),
      updatedAt: Value(DateTime.now()),
    );
  }
}
