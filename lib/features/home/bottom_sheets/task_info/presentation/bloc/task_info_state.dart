part of 'task_info_bloc.dart';

abstract class TaskInfoState extends Equatable {
  const TaskInfoState();

  @override
  List<Object?> get props => [];
}

class TaskInfoInitial extends TaskInfoState {
  const TaskInfoInitial();
}

class TaskInfoSuccess extends TaskInfoState {
  const TaskInfoSuccess({required this.task});

  final TaskWrapperEntity task;

  @override
  List<Object?> get props => [task];
}
