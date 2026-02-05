import 'package:equatable/equatable.dart';

class FriendRequestUserEntity extends Equatable {
  const FriendRequestUserEntity({
    required this.id,
    required this.displayName,
    this.name,
    this.imageUrl,
  });

  final String id;
  final String displayName;
  final String? name;
  final String? imageUrl;

  FriendRequestUserEntity copyWith({
    String? id,
    String? displayName,
    String? name,
    String? imageUrl,
  }) {
    return FriendRequestUserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        name,
        imageUrl,
      ];
}
