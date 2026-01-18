part of 'edit_task_bloc.dart';

@freezed
class EditTaskState with _$EditTaskState {
  const factory EditTaskState.initial() = _Initial;
  const factory EditTaskState.loaded(
    String title,
    String description,
    int? taskId,
    int? networkId,
    bool isCompleted,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    bool isAllDay,
    bool titleIsNotEmpty,
    List<SubTaskUiModel> subTasks,
  ) = _LoadedState;
}

extension EditTaskStateX on EditTaskState {
  bool get titleIsNotEmpty => maybeWhen(
    loaded:
        (
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
          subTasks,
        ) => titleIsNotEmpty,
    orElse: () => false,
  );

  _LoadedState? get loadedOrNull => maybeMap(
    loaded: (state) => state,
    orElse: () => null,
  );
}
