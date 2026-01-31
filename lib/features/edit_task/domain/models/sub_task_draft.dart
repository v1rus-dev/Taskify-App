import 'package:equatable/equatable.dart';

class SubTaskDraft extends Equatable {
  const SubTaskDraft({
    this.id,
    required this.title,
    required this.isCompleted,
  });

  final int? id;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, title, isCompleted];
}
