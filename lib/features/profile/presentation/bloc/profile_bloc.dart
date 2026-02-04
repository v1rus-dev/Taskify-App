import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/models/time_format_type.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_side_effect.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    with BlocSideEffectMixin<ProfileBloc, ProfileSideEffect> {
  final AppConfigurationInteractor appConfigurationInteractor;
  final ProfileRepository profileRepository;

  final _sideEffectController = StreamController<ProfileSideEffect>();
  StreamSubscription<AppConfigurationsTableData?>? _configSubscription;

  @override
  Stream<ProfileSideEffect> get sideEffects => _sideEffectController.stream;

  ProfileBloc({
    required this.appConfigurationInteractor,
    required this.profileRepository,
  }) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileTimeFormatChanged>(_onTimeFormatChanged);
    on<ProfileUpdateTimeFormat>(_onUpdateTimeFormat);
    on<ProfileRemoveAccount>(_onRemoveAccount);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    _observeTimeFormat();
    final initial = await profileRepository.getProfile();
    initial.fold(
      ifLeft: (_) => null,
      ifRight: (user) => emit(state.copyWith(profileUser: user)),
    );
    await emit.forEach(
      profileRepository.observeProfile(),
      onData: (result) => result.fold(
        ifLeft: (_) => state.copyWith(clearProfileUser: true),
        ifRight: (user) => user == null
            ? state.copyWith(clearProfileUser: true)
            : state.copyWith(profileUser: user),
      ),
    );
  }

  void _onTimeFormatChanged(
    ProfileTimeFormatChanged event,
    Emitter<ProfileState> emit,
  ) {
    appConfigurationInteractor.setTimeFormat(event.timeFormat);
  }

  void _onUpdateTimeFormat(
    ProfileUpdateTimeFormat event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(timeFormat: event.timeFormat));
  }

  void _onRemoveAccount(
    ProfileRemoveAccount event,
    Emitter<ProfileState> emit,
  ) async {
    await profileRepository.clearProfile();
    emit(state.copyWith(clearProfileUser: true));
  }

  void _observeTimeFormat() {
    _configSubscription = appConfigurationInteractor
        .observeConfiguration()
        .listen((config) {
          add(
            ProfileUpdateTimeFormat(
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
