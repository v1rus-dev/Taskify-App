import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/features/profile/data/models/friend_tag_response_model.dart';

class FriendsApi {
  FriendsApi(this._client);

  final DioClient _client;

  Future<Either<Failure, FriendTagResponseModel>> generateFriendTag() {
    return _client.put(
      path: 'friends/tag',
      parser: (data) => FriendTagResponseModel.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }
}
