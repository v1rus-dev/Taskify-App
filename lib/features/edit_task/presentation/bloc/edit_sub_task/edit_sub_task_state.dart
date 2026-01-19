part of 'edit_sub_task_bloc.dart';

@freezed
abstract class EditSubTaskState with _$EditSubTaskState {
  const factory EditSubTaskState({
    @Default(<SubTaskUiModel>[]) List<SubTaskUiModel> subTasks,
  }) = _Initial;
}
