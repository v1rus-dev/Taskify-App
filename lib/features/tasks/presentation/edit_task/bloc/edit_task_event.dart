part of 'edit_task_bloc.dart';

abstract class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object?> get props => [];
}

class EditTaskStarted extends EditTaskEvent {
  const EditTaskStarted();
}

class EditTaskTitleChanged extends EditTaskEvent {
  const EditTaskTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class EditTaskDescriptionChanged extends EditTaskEvent {
  const EditTaskDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class EditTaskRecurrenceChanged extends EditTaskEvent {
  const EditTaskRecurrenceChanged(this.recurrence);

  final TaskRecurrence? recurrence;

  @override
  List<Object?> get props => [recurrence];
}

class EditTaskReminderChanged extends EditTaskEvent {
  const EditTaskReminderChanged(this.reminder);

  final TaskReminder? reminder;

  @override
  List<Object?> get props => [reminder];
}

class EditTaskSelectDate extends EditTaskEvent {
  const EditTaskSelectDate(
    this.date,
    this.isAllDay,
    this.startTime,
    this.endTime,
  );

  final DateTime date;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;

  @override
  List<Object?> get props => [date, isAllDay, startTime, endTime];
}

class EditTaskDateSelected extends EditTaskEvent {
  const EditTaskDateSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class EditTaskDurationTypeSelected extends EditTaskEvent {
  const EditTaskDurationTypeSelected(this.type);

  final TaskDurationType type;

  @override
  List<Object?> get props => [type];
}

class EditTaskTimeRangeSelected extends EditTaskEvent {
  const EditTaskTimeRangeSelected(this.startTime, this.endTime);

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}

class EditTaskDateSelectionCleared extends EditTaskEvent {
  const EditTaskDateSelectionCleared();
}

class EditTaskTagsUpdated extends EditTaskEvent {
  const EditTaskTagsUpdated(this.tags);

  final List<TagEntity> tags;

  @override
  List<Object?> get props => [tags];
}

class EditTaskSaveTask extends EditTaskEvent {
  const EditTaskSaveTask(this.title, this.description, this.subTasks);

  final String title;
  final String description;
  final List<SubTaskModelUi> subTasks;

  @override
  List<Object?> get props => [title, description, subTasks];
}

class EditTaskAutoSaveRequested extends EditTaskEvent {
  const EditTaskAutoSaveRequested(this.subTasks);

  final List<SubTaskModelUi> subTasks;

  @override
  List<Object?> get props => [subTasks];
}

class EditTaskSubTasksChanged extends EditTaskEvent {
  const EditTaskSubTasksChanged(this.subTasks, {this.shouldSchedule = true});

  final List<SubTaskModelUi> subTasks;
  final bool shouldSchedule;

  @override
  List<Object?> get props => [subTasks, shouldSchedule];
}

class EditTaskRemoveTag extends EditTaskEvent {
  const EditTaskRemoveTag(this.tag);

  final TagEntity tag;

  @override
  List<Object?> get props => [tag];
}

class TryTaskRemove extends EditTaskEvent {
  const TryTaskRemove();
}
