import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    int? id,
    int? networkId,
    String? clientId,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    required DateTime date,
    DateTime? startTime,
    DateTime? endTime,
    @Default(true) bool isAllDay,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _TaskEntity;
}
