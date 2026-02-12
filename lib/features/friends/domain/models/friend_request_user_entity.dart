import 'package:equatable/equatable.dart';

class FriendRequestUserEntity extends Equatable {
  const FriendRequestUserEntity({
    required this.id,
    required this.displayName,
    this.name,
    this.avatarUrl,
    this.anonymousNumber,
  });

  final String id;
  final String displayName;
  final String? name;
  final String? avatarUrl;
  final String? anonymousNumber;

  FriendRequestUserEntity copyWith({
    String? id,
    String? displayName,
    String? name,
    String? avatarUrl,
    String? anonymousNumber,
  }) {
    return FriendRequestUserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      anonymousNumber: anonymousNumber ?? this.anonymousNumber,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    name,
    avatarUrl,
    anonymousNumber,
  ];
}
