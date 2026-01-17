class SubTaskEntity {
  const SubTaskEntity({
    this.id,
    this.networkId,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
  });

  final int? id;
  final int? networkId;
  final int taskId;
  final String title;
  final bool isCompleted;
}
