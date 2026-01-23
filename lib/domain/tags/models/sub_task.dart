import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_task.freezed.dart';

@freezed
abstract class SubTaskEntity with _$SubTaskEntity {
  const factory SubTaskEntity({
    int? id,
    int? networkId,
    String? clientId,
    required int taskId,
    required String title,
    required bool isCompleted,
    DateTime? deletedAt,
  }) = _SubTaskEntity;
}
