import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/notifications/domain/models/pending_notification_entity.dart';
import 'package:taskify/features/notifications/domain/services/task_notification_scheduler.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/data/models/task_reminder.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocalTaskNotificationScheduler implements TaskNotificationScheduler {
  LocalTaskNotificationScheduler({
    required FlutterLocalNotificationsPlugin plugin,
    required TaskInteractor taskInteractor,
  }) : _plugin = plugin,
       _taskInteractor = taskInteractor;

  final FlutterLocalNotificationsPlugin _plugin;
  final TaskInteractor _taskInteractor;
  bool _isInitialized = false;

  static const String _channelId = 'task_reminders';
  static const String _channelName = 'Task reminders';
  static const String _channelDescription = 'Reminder notifications for tasks';
  static const String _defaultBody = 'It is time to check your task';
  static const int _debugNotificationIdStart = 900000;
  static const int _debugNotificationIdMax = 1900000000;
  static int _nextDebugNotificationId = _debugNotificationIdStart;

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
    macOS: DarwinNotificationDetails(),
  );

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    tz_data.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(settings: settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _isInitialized = true;
  }

  @override
  Future<void> syncTaskReminder(TaskEntity task) async {
    final taskId = task.id;
    if (taskId == null) {
      return;
    }

    try {
      await initialize();

      final notifyAt = _resolveNotifyAt(task);
      if (notifyAt == null) {
        await cancelTaskReminder(taskId);
        return;
      }

      final now = DateTime.now();
      if (!notifyAt.isAfter(now)) {
        await cancelTaskReminder(taskId);
        return;
      }

      final scheduledDate = tz.TZDateTime.from(notifyAt.toUtc(), tz.UTC);
      await _plugin.zonedSchedule(
        id: taskId,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        title: task.title,
        body: _resolveBody(task),
        payload: taskId.toString(),
      );
    } catch (error) {
      TalkerService.instance.error(
        'notification syncTaskReminder failed',
        error,
      );
    }
  }

  @override
  Future<void> cancelTaskReminder(int taskId) async {
    try {
      await initialize();
      await _plugin.cancel(id: taskId);
    } catch (error) {
      TalkerService.instance.error(
        'notification cancelTaskReminder failed',
        error,
      );
    }
  }

  @override
  Future<void> cancelNotification(int notificationId) async {
    try {
      await initialize();
      await _plugin.cancel(id: notificationId);
    } catch (error) {
      TalkerService.instance.error('notification cancel failed', error);
      rethrow;
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      await initialize();
      await _plugin.cancelAll();
    } catch (error) {
      TalkerService.instance.error('notification cancel all failed', error);
      rethrow;
    }
  }

  @override
  Future<void> reconcileAllTasks() async {
    try {
      await initialize();
      final result = await _taskInteractor.getTasks();
      final tasks = result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error(
            'notification reconcile tasks load failed',
            failure,
          );
          return <TaskEntity>[];
        },
        ifRight: (items) => items,
      );

      final activeTaskIds = <int>{};
      for (final task in tasks) {
        final taskId = task.id;
        if (taskId == null) {
          continue;
        }
        activeTaskIds.add(taskId);
        await syncTaskReminder(task);
      }

      final pending = await _plugin.pendingNotificationRequests();
      for (final notification in pending) {
        if (!activeTaskIds.contains(notification.id)) {
          await _plugin.cancel(id: notification.id);
        }
      }
    } catch (error) {
      TalkerService.instance.error('notification reconcile failed', error);
    }
  }

  @override
  Future<List<PendingNotificationEntity>> getPendingNotifications() async {
    try {
      await initialize();
      final pending = await _plugin.pendingNotificationRequests();
      return pending
          .map(
            (notification) => PendingNotificationEntity(
              id: notification.id,
              title: notification.title,
              body: notification.body,
              payload: notification.payload,
            ),
          )
          .toList()
        ..sort((left, right) => left.id.compareTo(right.id));
    } catch (error) {
      TalkerService.instance.error('notification list pending failed', error);
      rethrow;
    }
  }

  @override
  Future<void> showInstantTestNotification({
    required String title,
    required String body,
  }) async {
    try {
      await initialize();
      await _plugin.show(
        id: _nextNotificationId(),
        title: title,
        body: body,
        notificationDetails: _notificationDetails,
      );
    } catch (error) {
      TalkerService.instance.error('notification show test failed', error);
      rethrow;
    }
  }

  @override
  Future<void> scheduleTestNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    try {
      await initialize();
      final now = DateTime.now();
      final notifyAt = now.add(delay);
      final scheduledDate = tz.TZDateTime.from(notifyAt.toUtc(), tz.UTC);
      await _plugin.zonedSchedule(
        id: _nextNotificationId(),
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        title: title,
        body: body,
      );
    } catch (error) {
      TalkerService.instance.error('notification schedule test failed', error);
      rethrow;
    }
  }

  DateTime? _resolveNotifyAt(TaskEntity task) {
    if (task.deletedAt != null || task.isCompleted || task.reminder == null) {
      return null;
    }

    final baseTime = _resolveBaseTime(task);
    final offset = _offsetFor(task.reminder!.type);
    return baseTime.subtract(offset);
  }

  DateTime _resolveBaseTime(TaskEntity task) {
    if (!task.isAllDay && task.startTime != null) {
      return task.startTime!.toLocal();
    }
    final date = task.date.toLocal();
    return DateTime(date.year, date.month, date.day, 9);
  }

  Duration _offsetFor(TaskReminderType type) {
    return switch (type) {
      TaskReminderType.atTime => Duration.zero,
      TaskReminderType.fiveMinutesBefore => const Duration(minutes: 5),
      TaskReminderType.tenMinutesBefore => const Duration(minutes: 10),
      TaskReminderType.fifteenMinutesBefore => const Duration(minutes: 15),
      TaskReminderType.thirtyMinutesBefore => const Duration(minutes: 30),
      TaskReminderType.oneHourBefore => const Duration(hours: 1),
      TaskReminderType.oneDayBefore => const Duration(days: 1),
    };
  }

  String _resolveBody(TaskEntity task) {
    final description = task.description?.trim();
    if (description == null || description.isEmpty) {
      return _defaultBody;
    }
    return description;
  }

  int _nextNotificationId() {
    if (_nextDebugNotificationId >= _debugNotificationIdMax) {
      _nextDebugNotificationId = _debugNotificationIdStart;
    }
    return _nextDebugNotificationId++;
  }
}
