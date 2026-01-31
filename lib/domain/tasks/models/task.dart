import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    this.id,
    this.networkId,
    this.clientId,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.date,
    this.startTime,
    this.endTime,
    this.isAllDay = true,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final int? id;
  final int? networkId;
  final String? clientId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  TaskEntity copyWith({
    int? id,
    int? networkId,
    String? clientId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        networkId,
        clientId,
        title,
        description,
        isCompleted,
        date,
        startTime,
        endTime,
        isAllDay,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
