import 'package:equatable/equatable.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';

class SpaceEntity extends Equatable {
  const SpaceEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.isLightweight,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final SpaceRole role;
  final bool isLightweight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SpaceEntity copyWith({
    String? id,
    String? name,
    String? description,
    SpaceRole? role,
    bool? isLightweight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      role: role ?? this.role,
      isLightweight: isLightweight ?? this.isLightweight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    role,
    isLightweight,
    createdAt,
    updatedAt,
  ];
}
