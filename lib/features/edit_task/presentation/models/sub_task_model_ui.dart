import 'package:equatable/equatable.dart';

class SubTaskModelUi extends Equatable {
  const SubTaskModelUi({
    required this.id,
    required this.localKey,
    required this.title,
    required this.isCompleted,
  });

  final int? id;
  final int localKey;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, localKey, title, isCompleted];
}
