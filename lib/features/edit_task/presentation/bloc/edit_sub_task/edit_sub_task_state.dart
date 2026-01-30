part of 'edit_sub_task_bloc.dart';

class EditSubTaskState extends Equatable {
  const EditSubTaskState({
    this.subTasks = const <SubTaskUiModel>[],
  });

  final List<SubTaskUiModel> subTasks;

  EditSubTaskState copyWith({
    List<SubTaskUiModel>? subTasks,
  }) {
    return EditSubTaskState(subTasks: subTasks ?? this.subTasks);
  }

  @override
  List<Object?> get props => [subTasks];
}
