import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppConfigurationInteractor appConfigurationInteractor;
  StreamSubscription<AppConfigurationsTableData?>? _configSubscription;
  
  SettingsBloc({required this.appConfigurationInteractor})
    : super(_SettingsState()) {
    on<_Started>(_onStarted);
    on<_TimeFormatChanged>(_onTimeFormatChanged);
    on<_SetTimeFormat>(_onSetTimeFormat);
  }

  void _onStarted(_Started event, Emitter<SettingsState> emit) {
    _observeTimeFormat();
  }

  void _onTimeFormatChanged(
    _TimeFormatChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(timeFormat: event.timeFormat));
  }

  void _onSetTimeFormat(
    _SetTimeFormat event,
    Emitter<SettingsState> emit,
  ) {
    appConfigurationInteractor.setTimeFormat(event.timeFormat);
  }

  void _observeTimeFormat() {
    _configSubscription = appConfigurationInteractor.observeConfiguration().listen((config) {
      add(SettingsEvent.setTimeFormat(timeFormatTypeFromBool(config?.use24Hour ?? true)));
    });
  }

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    return super.close();
  }
}
