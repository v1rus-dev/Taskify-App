import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/data/mappers/auth_mapper.dart';

abstract class ProfileRepository {
  Future<Either<Failure, AuthUserModel>> getProfile();
  Future<Either<Failure, void>> updateProfile(AuthUserModel user);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthLocalDataSource authLocalDataSource;

  ProfileRepositoryImpl({required this.authLocalDataSource});

  @override
  Future<Either<Failure, AuthUserModel>> getProfile() {
    return authLocalDataSource.getUser().then(
      (value) => value.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (user) => user == null
            ? Left(const CacheFailure('User not found'))
            : Right(user.toModel()),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> updateProfile(AuthUserModel user) {
    return authLocalDataSource
        .saveUser(user.toEntity())
        .then(
          (value) => value.fold(
            ifLeft: (failure) => Left(failure),
            ifRight: (_) => Right(null),
          ),
        );
  }
}
