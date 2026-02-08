import 'dart:async';
import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

class TaskHomeWidgetService {
  TaskHomeWidgetService(this._taskInteractor);

  final TaskInteractor _taskInteractor;

  StreamSubscription<List<TaskWrapperEntity>>? _tasksSubscription;
  StreamSubscription<Uri?>? _widgetClickSubscription;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;
    _widgetClickSubscription = HomeWidget.widgetClicked.listen(
      _handleWidgetUri,
      onError: (Object error, StackTrace stackTrace) {
        TalkerService.instance.error('homeWidget widget click stream error', error);
      },
    );

    _tasksSubscription = _taskInteractor.observeTasks().listen(
      _syncTasks,
      onError: (Object error, StackTrace stackTrace) {
        TalkerService.instance.error('homeWidget tasks observe error', error);
      },
    );

    final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (launchUri != null) {
      _handleWidgetUri(launchUri);
    }
  }

  Future<void> _syncTasks(List<TaskWrapperEntity> tasks) async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final todayTasks = tasks
        .where(
          (taskWrapper) =>
              !taskWrapper.task.isCompleted &&
              DateTime(
                    taskWrapper.task.date.year,
                    taskWrapper.task.date.month,
                    taskWrapper.task.date.day,
                  ) ==
                  normalizedToday,
        )
        .toList()
      ..sort((a, b) => a.task.createdAt.compareTo(b.task.createdAt));

    final payload = todayTasks
        .map(
          (taskWrapper) => {
            'id': taskWrapper.task.id,
            'title': taskWrapper.task.title,
          },
        )
        .toList();

    await HomeWidget.saveWidgetData<String>(
      'today_tasks_json',
      jsonEncode(payload),
    );
    await HomeWidget.saveWidgetData<int>('today_tasks_count', payload.length);

    await HomeWidget.updateWidget(
      androidName: 'TaskifyTodayWidgetProvider',
    );
  }

  void _handleWidgetUri(Uri? uri) {
    if (uri == null || uri.scheme != 'taskify') {
      return;
    }

    if (uri.host == 'create') {
      appRouter.go(RouterPaths.editTask);
      return;
    }

    if (uri.host == 'task') {
      final rawId = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
      final taskId = int.tryParse(rawId ?? '');
      if (taskId == null) {
        return;
      }

      appRouter.go(RouterPaths.editTask, extra: taskId);
    }
  }

  Future<void> dispose() async {
    await _tasksSubscription?.cancel();
    await _widgetClickSubscription?.cancel();
  }
}
