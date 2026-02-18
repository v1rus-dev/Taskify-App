import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';

class SyncTaskReminderUseCase {
  SyncTaskReminderUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call(TaskEntity task) {
    return _scheduler.syncTaskReminder(task);
  }
}
