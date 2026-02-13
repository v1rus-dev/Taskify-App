import 'package:equatable/equatable.dart';

enum TaskReminderType {
  atTime,
  fiveMinutesBefore,
  tenMinutesBefore,
  fifteenMinutesBefore,
  thirtyMinutesBefore,
  oneHourBefore,
  oneDayBefore,
}

class TaskReminder extends Equatable {
  const TaskReminder({required this.type});

  final TaskReminderType type;

  @override
  List<Object?> get props => [type];
}
