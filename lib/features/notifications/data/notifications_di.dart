import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/notifications/data/services/local_task_notification_scheduler.dart';
import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_task_reminder_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_all_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/get_pending_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/initialize_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/reconcile_task_reminders_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/schedule_test_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/show_instant_test_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/sync_task_reminder_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/task_reminders_startup_task.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

void initNotificationsDependencies() {
  locator.registerLazySingleton(FlutterLocalNotificationsPlugin.new);
  locator.registerLazySingleton<TaskNotificationScheduler>(
    () => LocalTaskNotificationScheduler(
      plugin: locator<FlutterLocalNotificationsPlugin>(),
      taskInteractor: locator<TaskInteractor>(),
    ),
  );

  locator.registerLazySingleton(
    () => InitializeNotificationsUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => SyncTaskReminderUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => CancelTaskReminderUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => ReconcileTaskRemindersUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => GetPendingNotificationsUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => ShowInstantTestNotificationUseCase(
      locator<TaskNotificationScheduler>(),
    ),
  );
  locator.registerLazySingleton(
    () => ScheduleTestNotificationUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => CancelNotificationUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => CancelAllNotificationsUseCase(locator<TaskNotificationScheduler>()),
  );
  locator.registerLazySingleton(
    () => TaskRemindersStartupTask(
      locator<InitializeNotificationsUseCase>(),
      locator<ReconcileTaskRemindersUseCase>(),
    ),
  );
}
