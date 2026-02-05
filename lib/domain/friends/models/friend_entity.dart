import 'package:equatable/equatable.dart';

class FriendEntity extends Equatable {
  const FriendEntity({
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

  FriendEntity copyWith({
    String? id,
    String? friendTag,
    String? name,
    String? avatarUrl,
    String? anonymousNumber,
  }) {
    return FriendEntity(
      id: id ?? this.id,
      friendTag: friendTag ?? this.friendTag,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      anonymousNumber: anonymousNumber ?? this.anonymousNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        friendTag,
        name,
        avatarUrl,
        anonymousNumber,
      ];
}
