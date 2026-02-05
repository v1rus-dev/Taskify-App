part of 'edit_sub_task_bloc.dart';

class EditSubTaskState extends Equatable {
  const EditSubTaskState({
    this.subTasks = const <SubTaskModelUi>[],
  });

  final List<SubTaskModelUi> subTasks;

  EditSubTaskState copyWith({
    List<SubTaskModelUi>? subTasks,
  }) {
    return EditSubTaskState(subTasks: subTasks ?? this.subTasks);
  }

  @override
  List<Object?> get props => [subTasks];
}
