import 'package:equatable/equatable.dart';
import 'package:taskify/domain/friends/models/friend_request_user_entity.dart';

class FriendRequestEntity extends Equatable {
  const FriendRequestEntity({
    required this.requestId,
    required this.user,
  });

  final String requestId;
  final FriendRequestUserEntity user;

  @override
  List<Object?> get props => [
        requestId,
        user,
      ];
}
