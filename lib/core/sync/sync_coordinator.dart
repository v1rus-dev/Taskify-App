import 'dart:async';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';
import 'package:taskify/domain/sync/models/sync_state.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:taskify/domain/sync/usecases/sync_interactor.dart';

class SyncCoordinator {
  SyncCoordinator({
    required SyncInteractor interactor,
    required SyncRepository syncRepository,
    required AuthRepository authRepository,
    FirebaseInstallations? installations,
  })  : _interactor = interactor,
        _syncRepository = syncRepository,
        _authRepository = authRepository,
        _installations = installations ?? FirebaseInstallations.instance;

  final SyncInteractor _interactor;
  final SyncRepository _syncRepository;
  final AuthRepository _authRepository;
  final FirebaseInstallations _installations;

  bool _isAuthenticated = false;
  bool _isSyncing = false;
  bool _pending = false;
  Timer? _debounceTimer;

  Future<void> onAppStart() async {
    TalkerService.instance.info('syncTag onAppStart');
    await _refreshAuthState();
    if (_isAuthenticated) {
      scheduleSync(reason: 'app_start');
    }
  }

  void setAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    TalkerService.instance.info(
      'syncTag auth changed: $_isAuthenticated',
    );
    if (_isAuthenticated) {
      scheduleSync(reason: 'auth');
    }
  }

  void onForeground() {
    scheduleSync(reason: 'foreground');
  }

  void onNetworkRestored() {
    scheduleSync(reason: 'network');
  }

  void scheduleSync({required String reason, Duration debounce = const Duration(seconds: 3)}) {
    if (!_isAuthenticated) {
      TalkerService.instance.info('syncTag scheduleSync skip (not auth)');
      return;
    }
    _pending = true;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => _runSync(reason));
  }

  Future<void> _runSync(String reason) async {
    if (_isSyncing) {
      TalkerService.instance.info('syncTag sync already running');
      return;
    }
    if (!_isAuthenticated) {
      TalkerService.instance.info('syncTag sync skip (not auth)');
      return;
    }
    _isSyncing = true;
    _pending = false;
    TalkerService.instance.info('syncTag sync run: $reason');
    final deviceId = await _ensureDeviceId();
    if (deviceId == null || deviceId.isEmpty) {
      TalkerService.instance.error('syncTag deviceId missing');
      _isSyncing = false;
      return;
    }

    final result = await _interactor.sync(deviceId: deviceId);
    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag sync failed', failure),
      ifRight: (_) =>
          TalkerService.instance.info('syncTag sync success'),
    );

    _isSyncing = false;
    if (_pending) {
      scheduleSync(reason: 'pending');
    }
  }

  Future<void> _refreshAuthState() async {
    final result = await _authRepository.getSession();
    result.fold(
      ifLeft: (_) => _isAuthenticated = false,
      ifRight: (session) => _isAuthenticated = session != null,
    );
    TalkerService.instance.info(
      'syncTag auth refreshed: $_isAuthenticated',
    );
  }

  Future<String?> _ensureDeviceId() async {
    final stateResult = await _syncRepository.getState();
    SyncState? state;
    stateResult.fold(
      ifLeft: (_) {},
      ifRight: (right) => state = right,
    );
    final existing = state?.deviceId;
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final id = await _installations.getId();
    final updated = (state ?? const SyncState(deviceId: null, lastCursor: 0))
        .copyWith(deviceId: id);
    await _syncRepository.saveState(updated);
    return id;
  }
}
