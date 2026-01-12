class AddTaskState {
  final String title;
  final String description;

  AddTaskState({
    this.title = '',
    this.description = '',
  });

  AddTaskState copyWith({
    String? title,
    String? description,
  }) {
    return AddTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}