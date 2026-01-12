enum TasksViewType {
  tasks,
  timeline,
}

extension TaskViewTypeExtensions on TasksViewType {
  String getTitle() => switch (this) {
    TasksViewType.tasks => 'Tasks',
    TasksViewType.timeline => 'Timeline',
  };
}