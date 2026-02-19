import 'package:taskify/features/notifications/domain/models/pending_notification_entity.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';

abstract class TaskNotificationScheduler {
  Future<void> initialize();
  Future<void> syncTaskReminder(TaskEntity task);
  Future<void> cancelTaskReminder(int taskId);
  Future<void> cancelNotification(int notificationId);
  Future<void> cancelAllNotifications();
  Future<void> reconcileAllTasks();
  Future<List<PendingNotificationEntity>> getPendingNotifications();
  Future<void> showInstantTestNotification({
    required String title,
    required String body,
  });
  Future<void> scheduleTestNotification({
    required String title,
    required String body,
    required Duration delay,
  });
}
