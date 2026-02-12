import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/auth/data/models/auth_user_response_model.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';

class UpdateFriendCodeInteractor {
  UpdateFriendCodeInteractor(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, AuthUserResponseModel>> call() {
    return _repository.generateNewFriendCode();
  }
}
