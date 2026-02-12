import 'package:equatable/equatable.dart';
import 'package:taskify/features/friends/domain/models/friend_entity.dart';

class FriendModelUi extends Equatable {
  const FriendModelUi({
    required this.id,
    required this.friendTag,
    this.name,
    this.avatarUrl,
    this.anonymousNumber,
  });

  final String id;
  final String friendTag;
  final String? name;
  final String? avatarUrl;
  final String? anonymousNumber;

  @override
  List<Object?> get props => [id, friendTag, name, avatarUrl, anonymousNumber];
}

extension FriendReadUiMapper on FriendEntity {
  FriendModelUi toUiModel() {
    return FriendModelUi(
      id: id,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      anonymousNumber: anonymousNumber,
    );
  }
}
