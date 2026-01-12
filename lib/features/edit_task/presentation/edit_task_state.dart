class EditTaskState {
  final String title;
  final String description;

  EditTaskState({
    this.title = '',
    this.description = '',
  });

  EditTaskState copyWith({
    String? title,
    String? description,
  }) {
    return EditTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
