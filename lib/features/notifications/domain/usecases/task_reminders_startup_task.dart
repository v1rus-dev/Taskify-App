import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/app_start_task.dart';
import 'package:taskify/features/notifications/domain/usecases/initialize_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/reconcile_task_reminders_use_case.dart';

class TaskRemindersStartupTask implements AppStartTask {
  TaskRemindersStartupTask(
    this._initializeNotificationsUseCase,
    this._reconcileTaskRemindersUseCase,
  );

  final InitializeNotificationsUseCase _initializeNotificationsUseCase;
  final ReconcileTaskRemindersUseCase _reconcileTaskRemindersUseCase;

  @override
  String get id => 'task_reminders_startup';

  @override
  bool get requiresAuth => false;

  @override
  Future<void> run() async {
    try {
      await _initializeNotificationsUseCase();
      await _reconcileTaskRemindersUseCase();
    } catch (error) {
      TalkerService.instance.error('startupTask task reminders failed', error);
    }
  }
}
