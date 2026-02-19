import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class CancelNotificationUseCase {
  CancelNotificationUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call(int notificationId) {
    return _scheduler.cancelNotification(notificationId);
  }
}
