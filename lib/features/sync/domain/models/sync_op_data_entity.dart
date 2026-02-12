class SyncOpDataEntity {
  const SyncOpDataEntity({
    this.title,
    this.description,
    this.isCompleted,
    this.text,
    this.taskId,
    this.taskClientId,
    this.name,
    this.color,
    this.isUserTag,
  });

  final String? title;
  final String? description;
  final bool? isCompleted;
  final String? text;
  final int? taskId;
  final String? taskClientId;
  final String? name;
  final String? color;
  final bool? isUserTag;
}
