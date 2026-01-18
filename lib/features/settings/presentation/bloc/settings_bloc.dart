import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_side_effect.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>
    with BlocSideEffectMixin<SettingsBloc, SettingsSideEffect> {
  final AppConfigurationInteractor appConfigurationInteractor;

  final _sideEffectController = StreamController<SettingsSideEffect>();
  StreamSubscription<AppConfigurationsTableData?>? _configSubscription;

  @override
  Stream<SettingsSideEffect> get sideEffects => _sideEffectController.stream;

  SettingsBloc({required this.appConfigurationInteractor})
    : super(_SettingsState()) {
    on<_Started>(_onStarted);
    on<_OnTimeFormatChanged>(_onTimeFormatChanged);
    on<_UpdateTimeFormat>(_onUpdateTimeFormat);
  }

  void _onStarted(_Started event, Emitter<SettingsState> emit) {
    _observeTimeFormat();
  }

  void _onTimeFormatChanged(
    _OnTimeFormatChanged event,
    Emitter<SettingsState> emit,
  ) {
    appConfigurationInteractor.setTimeFormat(event.timeFormat);
  }

  void _onUpdateTimeFormat(
    _UpdateTimeFormat event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(timeFormat: event.timeFormat));
  }

  void _observeTimeFormat() {
    _configSubscription = appConfigurationInteractor
        .observeConfiguration()
        .listen((config) {
          add(
            SettingsEvent.updateTimeFormat(
              timeFormatTypeFromBool(config?.use24Hour ?? true),
            ),
          );
        });
  }

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    _sideEffectController.close();
    return super.close();
  }
}
