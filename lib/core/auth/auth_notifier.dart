import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:taskify/domain/auth/models/auth_providers.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState()) {
    _loadSession(); // вместо Future.microtask в build()
  }

  final AuthRepository _authRepository;

  Future<void> signInWithGoogle() => _signIn(AuthProviders.google);
  Future<void> signInWithApple() => _signIn(AuthProviders.apple);

  Future<void> signOut() async {
    try {
      final result = await _authRepository.signOut();
      result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error('Sign out error', failure);
        },
        ifRight: (_) {
          emit(const AuthState());
          TalkerService.instance.info('Sign out successful');
        },
      );
    } catch (e) {
      TalkerService.instance.error('Sign out error', e);
    }
  }

  Future<void> _signIn(AuthProviders provider) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final result = await _authRepository.signIn(provider: provider);

      result.fold(
        ifLeft: (failure) {
          TalkerService.instance.error('Sign in error', failure);
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ));
        },
        ifRight: (session) {
          TalkerService.instance.info('Sign in successful');
          emit(state.copyWith(isLoading: false, session: session));
        },
      );
    } catch (e) {
      TalkerService.instance.error('Sign in error', e);
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
          TalkerService.instance.error('Load session error', failure);
        },
        ifRight: (session) {
          TalkerService.instance.info('Load session: ${session?.toString()}');
          if (session != null) {
            emit(state.copyWith(session: session));
          }
        },
      );
    } catch (e) {
      TalkerService.instance.error('Load session error', e);
    }
  }
}