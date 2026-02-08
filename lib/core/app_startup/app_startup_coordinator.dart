import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/app_startup/app_start_task.dart';
import 'package:taskify/domain/auth/repository/auth_repository.dart';

class AppStartupCoordinator {
  AppStartupCoordinator({
    required List<AppStartTask> tasks,
    required AuthRepository authRepository,
  })  : _tasks = tasks,
        _authRepository = authRepository;

  final List<AppStartTask> _tasks;
  final AuthRepository _authRepository;

  bool _appStarted = false;
  bool _isAuthenticated = false;
  bool _isRunning = false;
  bool _pending = false;

  void onAppStart() {
    _appStarted = true;
    _refreshAndTryRun();
  }

  void setAuthenticated(bool isAuthenticated) {
    if (_isAuthenticated == isAuthenticated) {
      return;
    }
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

  Future<void> _refreshAndTryRun() async {
    await _refreshAuthState();
    _tryRun('app_start');
  }

  Future<void> _refreshAuthState() async {
    final result = await _authRepository.getSession();
    result.fold(
      ifLeft: (_) => _isAuthenticated = false,
      ifRight: (session) => _isAuthenticated = session != null,
    );
    TalkerService.instance.info(
      'startupTask auth refreshed: $_isAuthenticated',
    );
  }
}
