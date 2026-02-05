import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/app_startup/app_start_task.dart';

class AppStartupCoordinator {
  AppStartupCoordinator({required List<AppStartTask> tasks}) : _tasks = tasks;

  final List<AppStartTask> _tasks;

  bool _appStarted = false;
  bool _isAuthenticated = false;
  bool _isRunning = false;
  bool _pending = false;

  void onAppStart() {
    _appStarted = true;
    _tryRun('app_start');
  }

  void setAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    TalkerService.instance.info(
      'startupTask auth changed: $_isAuthenticated',
    );
    if (_isAuthenticated) {
      _tryRun('auth');
    }
  }

  void _tryRun(String reason) {
    if (!_appStarted) {
      TalkerService.instance.info(
        'startupTask skip (not started)',
      );
      return;
    }
    if (!_isAuthenticated) {
      TalkerService.instance.info(
        'startupTask skip (not auth)',
      );
      return;
    }
    if (_isRunning) {
      _pending = true;
      TalkerService.instance.info(
        'startupTask pending (already running)',
      );
      return;
    }

    _runTasks(reason);
  }

  Future<void> _runTasks(String reason) async {
    _isRunning = true;
    _pending = false;
    TalkerService.instance.info('startupTask run: $reason');

    final tasks = _tasks.where((task) => !task.requiresAuth || _isAuthenticated);
    final futures = tasks.map(
      (task) async {
        try {
          await task.run();
          TalkerService.instance.info(
            'startupTask success: ${task.id}',
          );
        } catch (e) {
          TalkerService.instance.error(
            'startupTask failed: ${task.id}',
            e,
          );
        }
      },
    );

    await Future.wait(futures);

    _isRunning = false;
    if (_pending) {
      _tryRun('pending');
    }
  }
}
