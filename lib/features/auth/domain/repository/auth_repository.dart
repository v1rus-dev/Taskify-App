import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/auth/domain/models/auth_providers.dart';
import 'package:taskify/features/auth/domain/models/auth_session_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity?>> getSession();
  Future<Either<Failure, AuthSessionEntity>> signIn({
    required AuthProviders provider,
  });
  Future<Either<Failure, void>> signOut();
}
