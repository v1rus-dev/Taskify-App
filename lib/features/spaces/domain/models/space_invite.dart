import 'package:equatable/equatable.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';

class SpaceInviteEntity extends Equatable {
  const SpaceInviteEntity({
    required this.id,
    required this.spaceId,
    required this.role,
    required this.isRevoked,
    this.token,
    this.expiresAt,
    this.createdAt,
  });

  final String id;
  final String spaceId;
  final String? token;
  final SpaceRole role;
  final bool isRevoked;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
    id,
    spaceId,
    token,
    role,
    isRevoked,
    expiresAt,
    createdAt,
  ];
}
