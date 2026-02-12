import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/friends/domain/usecases/friends_interactor.dart';

class RegenerateFriendTagUseCase {
  RegenerateFriendTagUseCase(this._friendsInteractor);

  final FriendsInteractor _friendsInteractor;

  Future<Either<Failure, String>> call() {
    return _friendsInteractor.regenerateFriendTag();
  }
}
