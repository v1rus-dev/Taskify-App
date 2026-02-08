import 'package:equatable/equatable.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';

class FriendProfileEntity extends Equatable {
  const FriendProfileEntity({required this.friend, required this.isFriend});

  final FriendEntity friend;
  final bool isFriend;

  @override
  List<Object?> get props => [friend, isFriend];
}
