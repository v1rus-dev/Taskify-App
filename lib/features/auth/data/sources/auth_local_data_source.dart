import 'package:dart_either/dart_either.dart';
import 'package:drift/drift.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/auth/data/mappers/auth_user_mapper.dart';
import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/features/auth/domain/models/auth_user_entity.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, AuthUserEntity?>> getUser();
  Future<Either<Failure, void>> saveUser(AuthUserEntity user);
  Future<Either<Failure, void>> clearUser();
  Stream<Either<Failure, AuthUserEntity?>> observeUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Either<Failure, AuthUserEntity?>> getUser() async {
    try {
      final driftUser =
          await _database.select(_database.usersTable).getSingleOrNull();
      return Right(driftUser?.toDomain());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(AuthUserEntity user) async {
    try {
      await _database.transaction(() async {
        await _database.delete(_database.usersTable).go();
        await _database.into(_database.usersTable).insert(
              UsersTableCompanion.insert(
                id: user.id,
                provider: user.provider,
                providerUserId: user.providerUserId,
                email: user.email,
                friendTag: user.friendTag,
                name: Value(user.name),
                avatarUrl: Value(user.avatarUrl),
                createdAt: user.createdAt,
                updatedAt: user.updatedAt,
              ),
            );
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await _database.delete(_database.usersTable).go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, AuthUserEntity?>> observeUser() async* {
    try {
      final stream =
          _database.select(_database.usersTable).watchSingleOrNull();
      await for (final driftUser in stream) {
        yield Right(driftUser?.toDomain());
      }
    } catch (e) {
      yield Left(DatabaseFailure(e.toString()));
    }
  }
}
