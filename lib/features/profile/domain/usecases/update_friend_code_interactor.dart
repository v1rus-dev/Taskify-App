import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';

class UpdateFriendCodeInteractor {
  UpdateFriendCodeInteractor(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, AuthUserModel>> call() {
    return _repository.generateNewFriendCode();
  }
}
