import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/friends_list/data/repositories/friends_repository.dart';
import 'package:taskify/features/friends_list/domain/models/friend_model.dart';

class FriendsInteractor {
  FriendsInteractor(this._repository);

  final FriendsRepository _repository;

  Future<Either<Failure, List<FriendModel>>> getFriends() {
    return _repository.getFriends();
  }
}
