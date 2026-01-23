class SyncOpDataModel {
  const SyncOpDataModel({
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

  factory SyncOpDataModel.fromJson(Map<String, dynamic> json) {
    return SyncOpDataModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool?,
      text: json['text'] as String?,
      taskId: json['task_id'] as int?,
      taskClientId: json['task_client_id'] as String?,
      name: json['name'] as String?,
      color: json['color'] as String?,
      isUserTag: json['is_user_tag'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'text': text,
      'task_id': taskId,
      'task_client_id': taskClientId,
      'name': name,
      'color': color,
      'is_user_tag': isUserTag,
    };
  }
}
