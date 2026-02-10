import 'package:equatable/equatable.dart';

class SpaceTaskEntity extends Equatable {
  const SpaceTaskEntity({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.isCompleted,
    this.listId,
    this.description,
    this.assigneeId,
    this.claimedById,
    this.completedAt,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final String? listId;
  final String? description;
  final String? assigneeId;
  final String? claimedById;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    spaceId,
    title,
    listId,
    description,
    assigneeId,
    claimedById,
    isCompleted,
    completedAt,
    updatedAt,
  ];
}
