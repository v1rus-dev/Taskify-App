part of 'edit_task_bloc.dart';

enum EditTaskSaveStatus { saving, saved, error }

class EditTaskState extends Equatable {
  const EditTaskState({
    this.title = '',
    this.description = '',
    this.taskId,
    this.networkId,
    this.isCompleted = false,
    required this.selectedDate,
    this.startTime,
    this.endTime,
    this.isAllDay = true,
    this.titleIsNotEmpty = false,
    this.isDateModified = false,
    this.selectedTags = const <TagEntity>[],
    this.saveStatus = EditTaskSaveStatus.saved,
  });

  final String title;
  final String description;
  final int? taskId;
  final int? networkId;
  final bool isCompleted;
  final DateTime selectedDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final bool titleIsNotEmpty;
  final bool isDateModified;
  final List<TagEntity> selectedTags;
  final EditTaskSaveStatus saveStatus;

  EditTaskState copyWith({
    String? title,
    String? description,
    int? taskId,
    int? networkId,
    bool? isCompleted,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    bool? titleIsNotEmpty,
    bool? isDateModified,
    List<TagEntity>? selectedTags,
    EditTaskSaveStatus? saveStatus,
  }) {
    return EditTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      taskId: taskId ?? this.taskId,
      networkId: networkId ?? this.networkId,
      isCompleted: isCompleted ?? this.isCompleted,
      selectedDate: selectedDate ?? this.selectedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      titleIsNotEmpty: titleIsNotEmpty ?? this.titleIsNotEmpty,
      isDateModified: isDateModified ?? this.isDateModified,
      selectedTags: selectedTags ?? this.selectedTags,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        taskId,
        networkId,
        isCompleted,
        selectedDate,
        startTime,
        endTime,
        isAllDay,
        titleIsNotEmpty,
        isDateModified,
        selectedTags,
        saveStatus,
      ];
}
