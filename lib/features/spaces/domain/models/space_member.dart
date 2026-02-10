import 'package:equatable/equatable.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';

class SpaceMemberEntity extends Equatable {
  const SpaceMemberEntity({
    required this.spaceId,
    required this.userId,
    required this.role,
    this.name,
    this.avatarUrl,
    this.joinedAt,
  });

  final String spaceId;
  final String userId;
  final String? name;
  final String? avatarUrl;
  final SpaceRole role;
  final DateTime? joinedAt;

  @override
  List<Object?> get props => [spaceId, userId, name, avatarUrl, role, joinedAt];
}
