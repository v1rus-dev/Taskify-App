import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class CancelTaskReminderUseCase {
  CancelTaskReminderUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call(int taskId) {
    return _scheduler.cancelTaskReminder(taskId);
  }
}
