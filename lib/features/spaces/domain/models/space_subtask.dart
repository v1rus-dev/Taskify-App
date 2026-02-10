import 'package:equatable/equatable.dart';

class SpaceSubTaskEntity extends Equatable {
  const SpaceSubTaskEntity({
    required this.id,
    required this.spaceId,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String taskId;
  final String title;
  final bool isCompleted;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    spaceId,
    taskId,
    title,
    isCompleted,
    updatedAt,
  ];
}
