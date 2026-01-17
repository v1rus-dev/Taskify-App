import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier() : super();

  final AuthRepository _authRepository = locator<AuthRepository>();

  @override
  AuthState build() {
    Future.microtask(_loadSession);
    return const AuthState();
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final session = await _authRepository.signInWithGoogle();
      TalkerService.instance.info('Google sign in successful');
      state = state.copyWith(isLoading: false, session: session);
    } catch (e) {
      TalkerService.instance.error('Google sign in error', e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final session = await _authRepository.signInWithApple();
      TalkerService.instance.info('Apple sign in successful');
      state = state.copyWith(isLoading: false, session: session);
    } catch (e) {
      TalkerService.instance.error('Apple sign in error', e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AuthState();
      TalkerService.instance.info('Sign out successful');
    } catch (e) {
      TalkerService.instance.error('Sign out error', e);
    }
  }

  Future<void> _loadSession() async {
    try {
      final session = await _authRepository.getSession();
      TalkerService.instance.info('Load session: ${session?.toString()}');
      if (session != null) {
        state = state.copyWith(session: session);
      }
    } catch (e) {
      TalkerService.instance.error('Load session error', e);
    }
  }
}
