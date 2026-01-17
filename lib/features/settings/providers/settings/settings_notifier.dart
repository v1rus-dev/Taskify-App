import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/features/settings/providers/settings/settings_state.dart';

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(
  () => SettingsNotifier(db: locator<AppDatabase>()),
);

class SettingsNotifier extends Notifier<SettingsState> {
  SettingsNotifier({required this.db})
      : interactor = AppConfigurationInteractor(db),
        super();

  final AppDatabase db;
  final AppConfigurationInteractor interactor;
  StreamSubscription<AppConfigurationsTableData?>? _configSubscription;

  @override
  SettingsState build() {
    _observeTimeFormat();

    return const SettingsState(
      timeFormat: TimeFormatType.hour24,
    );
  }

  void _observeTimeFormat() {
    _configSubscription =
        interactor.observeConfiguration().listen((config) {
      final timeFormat = timeFormatTypeFromBool(config?.use24Hour ?? true);
      state = state.copyWith(
        timeFormat: timeFormat,
      );
    });

    ref.onDispose(() {
      _configSubscription?.cancel();
    });
  }

  Future<void> setTimeFormat(TimeFormatType type) async {
    return await interactor.setTimeFormat(type);
  }
}
