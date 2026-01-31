import 'dart:convert';

class WidgetTask {
  const WidgetTask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isAllDay,
    this.startTime,
    this.endTime,
  });

  final int id;
  final String title;
  final bool isCompleted;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'isAllDay': isAllDay,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      };

  factory WidgetTask.fromJson(Map<String, dynamic> json) {
    return WidgetTask(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isAllDay: json['isAllDay'] as bool? ?? true,
      startTime: _readDate(json['startTime']),
      endTime: _readDate(json['endTime']),
    );
  }
}

class WidgetAction {
  const WidgetAction({
    required this.taskId,
    required this.isCompleted,
    required this.updatedAt,
  });

  final int taskId;
  final bool isCompleted;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'isCompleted': isCompleted,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WidgetAction.fromJson(Map<String, dynamic> json) {
    return WidgetAction(
      taskId: json['taskId'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      updatedAt: _readDate(json['updatedAt']) ?? DateTime.now(),
    );
  }
}

class WidgetSnapshot {
  const WidgetSnapshot({
    required this.version,
    required this.date,
    required this.generatedAt,
    required this.tasks,
    required this.pendingActions,
  });

  final int version;
  final String date;
  final DateTime generatedAt;
  final List<WidgetTask> tasks;
  final List<WidgetAction> pendingActions;

  Map<String, dynamic> toJson() => {
        'version': version,
        'date': date,
        'generatedAt': generatedAt.toIso8601String(),
        'tasks': tasks.map((task) => task.toJson()).toList(),
        'pendingActions':
            pendingActions.map((action) => action.toJson()).toList(),
      };

  factory WidgetSnapshot.fromJson(Map<String, dynamic> json) {
    return WidgetSnapshot(
      version: json['version'] as int? ?? 1,
      date: json['date'] as String? ?? _formatDate(DateTime.now()),
      generatedAt: _readDate(json['generatedAt']) ?? DateTime.now(),
      tasks: (json['tasks'] as List<dynamic>? ?? [])
          .map((item) => WidgetTask.fromJson(item as Map<String, dynamic>))
          .toList(),
      pendingActions: (json['pendingActions'] as List<dynamic>? ?? [])
          .map((item) => WidgetAction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String encode() => jsonEncode(toJson());

  static WidgetSnapshot decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return WidgetSnapshot.fromJson(json);
  }

  WidgetSnapshot copyWith({
    int? version,
    String? date,
    DateTime? generatedAt,
    List<WidgetTask>? tasks,
    List<WidgetAction>? pendingActions,
  }) {
    return WidgetSnapshot(
      version: version ?? this.version,
      date: date ?? this.date,
      generatedAt: generatedAt ?? this.generatedAt,
      tasks: tasks ?? this.tasks,
      pendingActions: pendingActions ?? this.pendingActions,
    );
  }

  static WidgetSnapshot emptyToday() {
    return WidgetSnapshot(
      version: 1,
      date: _formatDate(DateTime.now()),
      generatedAt: DateTime.now(),
      tasks: const [],
      pendingActions: const [],
    );
  }
}

DateTime? _readDate(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
