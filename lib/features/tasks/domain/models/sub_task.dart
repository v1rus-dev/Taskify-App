import 'package:equatable/equatable.dart';

class SubTaskEntity extends Equatable {
  const SubTaskEntity({
    this.id,
    this.networkId,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    this.deletedAt,
  });

  final int? id;
  final int? networkId;
  final int taskId;
  final String title;
  final bool isCompleted;
  final DateTime? deletedAt;

  SubTaskEntity copyWith({
    int? id,
    int? networkId,
    int? taskId,
    String? title,
    bool? isCompleted,
    DateTime? deletedAt,
  }) {
    return SubTaskEntity(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        networkId,
        taskId,
        title,
        isCompleted,
        deletedAt,
      ];
}
