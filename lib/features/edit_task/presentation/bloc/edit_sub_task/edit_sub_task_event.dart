part of 'edit_sub_task_bloc.dart';

abstract class EditSubTaskEvent extends Equatable {
  const EditSubTaskEvent();

  @override
  List<Object?> get props => [];
}

class EditSubTaskStarted extends EditSubTaskEvent {
  const EditSubTaskStarted();
}

class EditSubTaskToggle extends EditSubTaskEvent {
  const EditSubTaskToggle(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class EditSubTaskRemoved extends EditSubTaskEvent {
  const EditSubTaskRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class EditSubTaskRemovedByLocalKey extends EditSubTaskEvent {
  const EditSubTaskRemovedByLocalKey(this.localKey);

  final int localKey;

  @override
  List<Object?> get props => [localKey];
}

class EditSubTaskTextChanged extends EditSubTaskEvent {
  const EditSubTaskTextChanged(this.index, this.text);

  final int index;
  final String text;

  @override
  List<Object?> get props => [index, text];
}

class EditSubTaskAdded extends EditSubTaskEvent {
  const EditSubTaskAdded();
}

class EditSubTaskReordered extends EditSubTaskEvent {
  const EditSubTaskReordered(this.oldIndex, this.newIndex);

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
