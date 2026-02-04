import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/data/api/friends_api.dart';
import 'package:taskify/features/friends_list/data/models/friend_response_model.dart';

abstract class FriendsNetworkDataSource {
  Future<Either<Failure, List<FriendResponseModel>>> getFriends({
    required String token,
  });
}

class FriendsNetworkDataSourceImpl implements FriendsNetworkDataSource {
  FriendsNetworkDataSourceImpl(this._api);

  final FriendsApi _api;

  @override
  Future<Either<Failure, List<FriendResponseModel>>> getFriends({
    required String token,
  }) {
    return _api.getFriends(token: token);
  }
}
