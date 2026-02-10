import 'package:equatable/equatable.dart';

class SpaceNoteEntity extends Equatable {
  const SpaceNoteEntity({
    required this.id,
    required this.spaceId,
    required this.title,
    this.body,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final String? body;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, spaceId, title, body, updatedAt];
}
