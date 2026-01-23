class SubTaskEntity {
  const SubTaskEntity({
    this.id,
    this.networkId,
    this.clientId,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
    this.deletedAt,
  });

  final int? id;
  final int? networkId;
  final String? clientId;
  final int taskId;
  final String title;
  final bool isCompleted;
  final DateTime? deletedAt;
}
