import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/domain/auth/models/auth_providers.dart';
import 'package:taskify/domain/auth/models/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession?>> getSession();
  Future<Either<Failure, AuthSession>> signIn({
    required AuthProviders provider,
  });
  Future<Either<Failure, void>> signOut();
}
