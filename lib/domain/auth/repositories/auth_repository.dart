import 'package:taskify/domain/auth/models/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> getSession();
  Future<AuthSession> signInWithGoogle();
  Future<AuthSession> signInWithApple();
  Future<void> signOut();
}
