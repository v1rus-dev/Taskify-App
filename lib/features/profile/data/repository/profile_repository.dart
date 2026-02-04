import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/data/mappers/auth_mapper.dart';
import 'package:taskify/data/api/friends_api.dart';

abstract class ProfileRepository {
  Future<Either<Failure, AuthUserModel>> getProfile();
  Future<Either<Failure, void>> updateProfile(AuthUserModel user);
  Future<Either<Failure, void>> clearProfile();
  Stream<Either<Failure, AuthUserModel?>> observeProfile();
  Future<Either<Failure, AuthUserModel>> generateNewFriendCode();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthLocalDataSource authLocalDataSource;
  final FriendsApi friendsApi;

  ProfileRepositoryImpl({
    required this.authLocalDataSource,
    required this.friendsApi,
  });

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

  @override
  Future<Either<Failure, void>> clearProfile() {
    return authLocalDataSource.clearUser().then(
          (value) => value.fold(
            ifLeft: (failure) => Left(failure),
            ifRight: (_) => Right(null),
          ),
        );
  }

  @override
  Stream<Either<Failure, AuthUserModel?>> observeProfile() {
    return authLocalDataSource.observeUser().map(
          (result) => result.fold(
            ifLeft: (failure) => Left(failure),
            ifRight: (user) => Right(user?.toModel()),
          ),
        );
  }

  @override
  Future<Either<Failure, AuthUserModel>> generateNewFriendCode() async {
    final tagResult = await friendsApi.generateFriendTag();
    Failure? tagFailure;
    String? friendTag;
    tagResult.fold(
      ifLeft: (left) => tagFailure = left,
      ifRight: (right) => friendTag = right.friendTag,
    );
    if (tagFailure != null) {
      return Left(tagFailure!);
    }

    final userResult = await authLocalDataSource.getUser();
    Failure? userFailure;
    AuthUserModel? userModel;
    userResult.fold(
      ifLeft: (left) => userFailure = left,
      ifRight: (user) => userModel = user?.toModel(),
    );
    if (userFailure != null) {
      return Left(userFailure!);
    }
    if (userModel == null) {
      return Left(const CacheFailure('User not found'));
    }

    final updatedUser = AuthUserModel(
      id: userModel!.id,
      provider: userModel!.provider,
      providerUserId: userModel!.providerUserId,
      email: userModel!.email,
      friendTag: friendTag ?? userModel!.friendTag,
      name: userModel!.name,
      avatarUrl: userModel!.avatarUrl,
      createdAt: userModel!.createdAt,
      updatedAt: userModel!.updatedAt,
    );

    final saveResult = await authLocalDataSource.saveUser(
      updatedUser.toEntity(),
    );
    Failure? saveFailure;
    saveResult.fold(
      ifLeft: (left) => saveFailure = left,
      ifRight: (_) {},
    );
    if (saveFailure != null) {
      return Left(saveFailure!);
    }

    return Right(updatedUser);
  }
}
