import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_side_effect.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    with BlocSideEffectMixin<ProfileBloc, ProfileSideEffect> {
  final AppConfigurationInteractor appConfigurationInteractor;

  final _sideEffectController = StreamController<ProfileSideEffect>();
  StreamSubscription<AppConfigurationsTableData?>? _configSubscription;

  @override
  Stream<ProfileSideEffect> get sideEffects => _sideEffectController.stream;

  ProfileBloc({required this.appConfigurationInteractor})
    : super(_ProfileState()) {
    on<_Started>(_onStarted);
    on<_OnTimeFormatChanged>(_onTimeFormatChanged);
    on<_UpdateTimeFormat>(_onUpdateTimeFormat);
    on<_OnRemoveAccount>(_onRemoveAccount);
  }

  void _onStarted(_Started event, Emitter<ProfileState> emit) {
    _observeTimeFormat();
  }

  void _onTimeFormatChanged(
    _OnTimeFormatChanged event,
    Emitter<ProfileState> emit,
  ) {
    appConfigurationInteractor.setTimeFormat(event.timeFormat);
  }

  void _onUpdateTimeFormat(
    _UpdateTimeFormat event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(timeFormat: event.timeFormat));
  }

  void _onRemoveAccount(_OnRemoveAccount event, Emitter<ProfileState> emit) {}

  void _observeTimeFormat() {
    _configSubscription = appConfigurationInteractor
        .observeConfiguration()
        .listen((config) {
          add(
            ProfileEvent.updateTimeFormat(
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
