import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final int? networkId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime date;
  final DateTime? startTime;
  final bool isAllDay;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Task({
    this.id,
    this.networkId,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.date,
    this.startTime,
    this.isAllDay = true,
    required this.createdAt,
    this.updatedAt,
  });

  Task copyWith({
    int? id,
    int? networkId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
    DateTime? startTime,
    bool? isAllDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      isAllDay: isAllDay ?? this.isAllDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        networkId,
        title,
        description,
        isCompleted,
        date,
        startTime,
        isAllDay,
        createdAt,
        updatedAt,
      ];
}
