import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/friends_list/data/datasources/friends_network_datasource.dart';
import 'package:taskify/features/friends_list/domain/models/friend_model.dart';
import 'package:taskify/core/auth/access_token_provider.dart';

abstract class FriendsRepository {
  Future<Either<Failure, List<FriendModel>>> getFriends();
}

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl({
    required FriendsNetworkDataSource networkDataSource,
    required AuthTokenHandler authTokenHandler,
  }) : _networkDataSource = networkDataSource,
       _authTokenHandler = authTokenHandler;

  final FriendsNetworkDataSource _networkDataSource;
  final AuthTokenHandler _authTokenHandler;

  @override
  Future<Either<Failure, List<FriendModel>>> getFriends() async {
    final accessToken = await _authTokenHandler.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return Left(const CacheFailure('No access token found'));
    }
    final result = await _networkDataSource.getFriends(token: accessToken);
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (friends) =>
          Right(friends.map((friend) => friend.toDomain()).toList()),
    );
  }
}
