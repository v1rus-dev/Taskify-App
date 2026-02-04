import 'package:equatable/equatable.dart';
import 'package:taskify/features/friends_list/domain/models/friend_model.dart';

class FriendUiModel extends Equatable {
  const FriendUiModel({
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
  List<Object?> get props => [
        id,
        friendTag,
        name,
        avatarUrl,
        anonymousNumber,
      ];
}

extension FriendReadUiMapper on FriendModel {
  FriendUiModel toUiModel() {
    return FriendUiModel(
      id: id,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      anonymousNumber: anonymousNumber,
    );
  }
}
