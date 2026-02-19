import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';

class ReconcileTaskRemindersUseCase {
  ReconcileTaskRemindersUseCase(this._scheduler);

  final TaskNotificationScheduler _scheduler;

  Future<void> call() {
    return _scheduler.reconcileAllTasks();
  }
}
