part of 'edit_task_bloc.dart';

@freezed
class EditTaskSideEffect with _$EditTaskSideEffect {
  const factory EditTaskSideEffect.showLoadingDialog() = _ShowLoadingDialog;
  const factory EditTaskSideEffect.initEditTextControllers(String title, String description) = _InitEditTextControllers;
}