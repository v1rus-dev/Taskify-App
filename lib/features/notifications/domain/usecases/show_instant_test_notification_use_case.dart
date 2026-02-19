import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class ShowInstantTestNotificationUseCase {
  ShowInstantTestNotificationUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call({required String title, required String body}) {
    return _scheduler.showInstantTestNotification(title: title, body: body);
  }
}
