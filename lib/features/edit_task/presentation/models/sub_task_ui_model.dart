class SubTaskUiModel {
  const SubTaskUiModel({
    required this.id,
    required this.localKey,
    required this.title,
    required this.isCompleted,
  });

  final int? id;
  final int localKey;
  final String title;
  final bool isCompleted;
}
