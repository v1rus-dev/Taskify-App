import 'package:taskify/core/services/talker_service.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/native_widgets/task_widget_models.dart';
import 'package:taskify/core/native_widgets/task_widget_store.dart';
import 'package:taskify/core/native_widgets/task_widget_bridge.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/data/database/app_database.dart' as db;

class TaskWidgetSyncService {
  TaskWidgetSyncService(
    this._taskLocalDataSource,
    this._store,
    this._bridge,
  );

  final TaskLocalDataSource _taskLocalDataSource;
  final TaskWidgetStore _store;
  final TaskWidgetBridge _bridge;

  Future<void> initialize() async {
    await applyPendingActions();
    await refreshTodaySnapshot();
  }

  Future<void> applyPendingActions() async {
    final snapshot = await _store.readSnapshot();
    if (snapshot.pendingActions.isEmpty) {
      return;
    }

    final remaining = <WidgetAction>[];

    for (final action in snapshot.pendingActions) {
      final taskResult = await _taskLocalDataSource.getTaskById(action.taskId);
      db.TasksTableData? task;
      taskResult.fold(
        ifLeft: (_) {},
        ifRight: (value) => task = value,
      );
      final resolved = task;
      if (resolved == null) {
        remaining.add(action);
        continue;
      }
      final updated = resolved.copyWith(
        isCompleted: action.isCompleted,
        updatedAt: Value(DateTime.now()),
      );
      final updateResult = await _taskLocalDataSource.updateTask(updated);
      updateResult.fold(
        ifLeft: (_) => remaining.add(action),
        ifRight: (_) {},
      );
    }

    final updatedSnapshot = snapshot.copyWith(
      pendingActions: remaining,
      generatedAt: DateTime.now(),
    );
    await _store.writeSnapshot(updatedSnapshot);
  }

  Future<void> refreshTodaySnapshot() async {
    final now = DateTime.now();
    final result = await _taskLocalDataSource.getTasksByDate(now);
    List<db.TasksTableData> tasks = <db.TasksTableData>[];
    var hasError = false;
    result.fold(
      ifLeft: (_) {
        hasError = true;
        TalkerService.instance.error('syncTag Widget snapshot error');
      },
      ifRight: (value) => tasks = value,
    );
    if (hasError) {
      return;
    }
    if (tasks.isEmpty) {
      await _store.writeSnapshot(
        (await _store.readSnapshot()).copyWith(
          date: _formatDate(now),
          generatedAt: DateTime.now(),
          tasks: const [],
        ),
      );
      await _bridge.refreshWidgets();
      return;
    }

    tasks = tasks.where((task) => !task.isCompleted).toList();

    tasks.sort((a, b) {
      final aStart = a.startTime;
      final bStart = b.startTime;
      if (aStart != null && bStart != null) {
        final compare = aStart.compareTo(bStart);
        if (compare != 0) {
          return compare;
        }
      } else if (aStart != null) {
        return -1;
      } else if (bStart != null) {
        return 1;
      }
      return a.createdAt.compareTo(b.createdAt);
    });

    final widgetTasks = tasks
        .take(20)
        .map(
          (task) => WidgetTask(
            id: task.id,
            title: task.title,
            isCompleted: task.isCompleted,
            isAllDay: task.isAllDay,
            startTime: task.startTime,
            endTime: task.endTime,
          ),
        )
        .toList();

    final snapshot = (await _store.readSnapshot()).copyWith(
      date: _formatDate(now),
      generatedAt: DateTime.now(),
      tasks: widgetTasks,
    );

    await _store.writeSnapshot(snapshot);
    await _bridge.refreshWidgets();
  }
}

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
