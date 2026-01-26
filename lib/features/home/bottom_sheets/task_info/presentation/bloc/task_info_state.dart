part of 'task_info_bloc.dart';

@freezed
abstract class TaskInfoState with _$TaskInfoState {

  const factory TaskInfoState.initial() = _Initial;
  const factory TaskInfoState.success({required TaskWrapperEntity task}) =
      _Success;
}
