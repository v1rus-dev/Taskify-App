import 'package:taskify/features/notifications/domain/models/pending_notification_entity.dart';
import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class GetPendingNotificationsUseCase {
  GetPendingNotificationsUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<List<PendingNotificationEntity>> call() {
    return _scheduler.getPendingNotifications();
  }
}
