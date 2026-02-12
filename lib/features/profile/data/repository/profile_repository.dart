import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/auth/data/models/auth_user_response_model.dart';
import 'package:taskify/features/auth/data/sources/auth_local_data_source.dart';
import 'package:taskify/features/auth/data/mappers/auth_mapper.dart';
import 'package:taskify/features/friends/domain/usecases/regenerate_friend_tag_use_case.dart';

abstract class ProfileRepository {
  Future<Either<Failure, AuthUserResponseModel>> getProfile();
  Future<Either<Failure, void>> updateProfile(AuthUserResponseModel user);
  Future<Either<Failure, void>> clearProfile();
  Stream<Either<Failure, AuthUserResponseModel?>> observeProfile();
  Future<Either<Failure, AuthUserResponseModel>> generateNewFriendCode();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthLocalDataSource authLocalDataSource;
  final RegenerateFriendTagUseCase regenerateFriendTagUseCase;

  ProfileRepositoryImpl({
    required this.authLocalDataSource,
    required this.regenerateFriendTagUseCase,
  });

  @override
  Future<Either<Failure, AuthUserResponseModel>> getProfile() {
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
  Future<Either<Failure, void>> updateProfile(AuthUserResponseModel user) {
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
  Stream<Either<Failure, AuthUserResponseModel?>> observeProfile() {
    return authLocalDataSource.observeUser().map(
      (result) => result.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (user) => Right(user?.toModel()),
      ),
    );
  }

  @override
  Future<Either<Failure, AuthUserResponseModel>> generateNewFriendCode() async {
    final tagResult = await regenerateFriendTagUseCase();
    Failure? tagFailure;
    String? friendTag;
    tagResult.fold(
      ifLeft: (left) => tagFailure = left,
      ifRight: (right) => friendTag = right,
    );
    if (tagFailure != null) {
      return Left(tagFailure!);
    }

    final userResult = await authLocalDataSource.getUser();
    Failure? userFailure;
    AuthUserResponseModel? userModel;
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

    final updatedUser = AuthUserResponseModel(
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
    saveResult.fold(ifLeft: (left) => saveFailure = left, ifRight: (_) {});
    if (saveFailure != null) {
      return Left(saveFailure!);
    }

    return Right(updatedUser);
  }
}
