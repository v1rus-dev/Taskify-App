import 'package:equatable/equatable.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';

class FriendRequestEntity extends Equatable {
  const FriendRequestEntity({
    required this.requestId,
    required this.isIncoming,
    required this.user,
  });

  final String requestId;
  final bool isIncoming;
  final FriendEntity user;

  @override
  List<Object?> get props => [requestId, isIncoming, user];
}
