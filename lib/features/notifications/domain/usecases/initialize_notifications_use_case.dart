import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class InitializeNotificationsUseCase {
  InitializeNotificationsUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call() {
    return _scheduler.initialize();
  }
}
