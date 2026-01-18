import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'dart:async';

part 'edit_task_event.dart';
part 'edit_task_state.dart';
part 'edit_task_bloc.freezed.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final int? taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  DateTime? _createdAt;
  List<int> _initialSubTaskIds = const [];

  EditTaskBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super(_Initial()) {
    on<_Started>(_onStarted);
    on<_SubTaskToggle>(_onSubTaskToggle);
    on<_SubTaskRemoved>(_onSubTaskRemoved);
    on<_SubTaskTextChanged>(_onSubTaskTextChanged);
    on<_SaveTask>(_onSaveTask);
  }

  Future<void> _onStarted(_Started event, Emitter<EditTaskState> emit) async {
    if (taskId != null) {
      await _getTaskById(taskId: taskId!);
      await _loadSubTasks(taskId: taskId!);
    }
  }

  void _onSubTaskToggle(_SubTaskToggle event, Emitter<EditTaskState> emit) {
    // final current = state.subTasks;
    // if (event.index >= current.length) {
    //   return;
    // }
  }

  void _onSubTaskRemoved(_SubTaskRemoved event, Emitter<EditTaskState> emit) {
    // final current = state.subTasks;
    // if (event.index >= current.length) {
    //   return;
    // }
  }

  void _onSubTaskTextChanged(_SubTaskTextChanged event, Emitter<EditTaskState> emit) {
    // final current = state.subTasks;
    // if (event.index >= current.length) {
    //   return;
    // }
  }

  Future<void> _onSaveTask(_SaveTask event, Emitter<EditTaskState> emit) async {
    final completer = event.completer;
    completer.complete();
  }

  Future<void> _getTaskById({required int taskId}) async {
    final result = await taskInteractor.getTaskById(taskId);

    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) => {TalkerService.instance.info('Task: ${task.id}')},
    );
  }

  Future<void> _loadSubTasks({required int taskId}) async {
    final result = await subTaskInteractor.getSubTasksByTaskId(taskId);
    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (subTasks) => {
        TalkerService.instance.info('SubTasks: ${subTasks.length}'),
      },
    );
  }
}
