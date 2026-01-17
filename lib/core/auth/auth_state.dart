import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/auth/models/auth_session.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    AuthSession? session,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;
}
