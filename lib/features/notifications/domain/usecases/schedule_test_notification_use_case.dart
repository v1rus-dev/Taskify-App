import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class ScheduleTestNotificationUseCase {
  ScheduleTestNotificationUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call({
    required String title,
    required String body,
    required Duration delay,
  }) {
    return _scheduler.scheduleTestNotification(
      title: title,
      body: body,
      delay: delay,
    );
  }
}
