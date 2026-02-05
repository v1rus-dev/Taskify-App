import 'package:equatable/equatable.dart';
import 'package:taskify/domain/auth/models/auth_session_entity.dart';

class AuthState extends Equatable {
  const AuthState({
    this.session,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthSessionEntity? session;
  final bool isLoading;
  final String? errorMessage;

  static const _unset = Object();

  AuthState copyWith({
    AuthSessionEntity? session,
    bool? isLoading,
    Object? errorMessage = _unset,
  }) {
    return AuthState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [session, isLoading, errorMessage];
}
