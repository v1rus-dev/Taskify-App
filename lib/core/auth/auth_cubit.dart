import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:taskify/domain/auth/models/auth_providers.dart';
import 'package:taskify/domain/auth/repository/auth_repository.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, {SyncCoordinator? syncCoordinator})
      : _syncCoordinator = syncCoordinator,
        super(const AuthState()) {
    _syncCoordinator?.onAppStart();
    _loadSession();
  }

  final AuthRepository _authRepository;
  final SyncCoordinator? _syncCoordinator;

  Future<void> signInWithGoogle() => _signIn(AuthProviders.google);
  Future<void> signInWithApple() => _signIn(AuthProviders.apple);

  Future<void> signOut() async {
    try {
      final result = await _authRepository.signOut();
      result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error('syncTag Sign out error', failure);
        },
        ifRight: (_) {
          emit(const AuthState());
          _syncCoordinator?.setAuthenticated(false);
          TalkerService.instance.info('syncTag Sign out successful');
        },
      );
    } catch (e) {
      TalkerService.instance.error('syncTag Sign out error', e);
    }
  }

  Future<void> _signIn(AuthProviders provider) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final result = await _authRepository.signIn(provider: provider);

      result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error('syncTag Sign in error', failure);
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ));
        },
        ifRight: (session) {
          TalkerService.instance.info('syncTag Sign in successful');
          emit(state.copyWith(isLoading: false, session: session));
          _syncCoordinator?.setAuthenticated(true);
        },
      );
    } catch (e) {
      TalkerService.instance.error('syncTag Sign in error', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _loadSession() async {
    try {
      final result = await _authRepository.getSession();
      result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error('syncTag Load session error', failure);
        },
        ifRight: (session) {
          TalkerService.instance.info('syncTag Load session: ${session?.toString()}');
          if (session != null) {
            emit(state.copyWith(session: session));
            _syncCoordinator?.setAuthenticated(true);
          } else {
            _syncCoordinator?.setAuthenticated(false);
          }
        },
      );
    } catch (e) {
      TalkerService.instance.error('syncTag Load session error', e);
    }
  }
}
