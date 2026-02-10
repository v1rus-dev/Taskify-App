import 'package:equatable/equatable.dart';

class SpaceListEntity extends Equatable {
  const SpaceListEntity({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.order,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final int order;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, spaceId, title, order, updatedAt];
}
