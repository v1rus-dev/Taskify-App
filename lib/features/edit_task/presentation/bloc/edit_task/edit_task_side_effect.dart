part of 'edit_task_bloc.dart';

abstract class EditTaskSideEffect extends Equatable {
  const EditTaskSideEffect();

  @override
  List<Object?> get props => [];
}

class EditTaskShowLoadingDialog extends EditTaskSideEffect {
  const EditTaskShowLoadingDialog();
}

class EditTaskInitEditTextControllers extends EditTaskSideEffect {
  const EditTaskInitEditTextControllers(this.title, this.description);

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}

class EditTaskShowConfirmationDialog extends EditTaskSideEffect {
  const EditTaskShowConfirmationDialog();
}

class EditTaskCloseScreen extends EditTaskSideEffect {
  const EditTaskCloseScreen();
}