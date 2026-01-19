import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/edit_task/domain/entities/sub_task.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';
part 'edit_task_side_effect.dart';
part 'edit_task_bloc.freezed.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState>
    with BlocSideEffectMixin<EditTaskBloc, EditTaskSideEffect> {
  final int? taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  DateTime? _createdAt;

  final _sideEffectController = StreamController<EditTaskSideEffect>();
  @override
  Stream<EditTaskSideEffect> get sideEffects => _sideEffectController.stream;

  EditTaskBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
  }) : super(EditTaskState(selectedDate: DateTime.now())) {
    on<_Started>(_onStarted);
    on<_TitleChanged>(_onTitleChanged);
    on<_SelectDate>(_onSelectDate);
    on<_SaveTask>(_onSaveTask);
  }

  Future<void> _onStarted(_Started event, Emitter<EditTaskState> emit) async {
    if (taskId != null) {
      await _getTaskById(taskId: taskId!, emit: emit);
    }
  }

  void _onTitleChanged(_TitleChanged event, Emitter<EditTaskState> emit) {
    emit(
      state.copyWith(
        title: event.title,
        titleIsNotEmpty: event.title.trim().isNotEmpty,
      ),
    );
  }

  void _onSelectDate(_SelectDate event, Emitter<EditTaskState> emit) {
    final resolvedStartTime = event.isAllDay ? null : event.startTime;
    final resolvedEndTime = event.isAllDay ? null : event.endTime;
    emit(
      state.copyWith(
        selectedDate: event.date,
        startTime: resolvedStartTime,
        endTime: resolvedEndTime,
        isAllDay: event.isAllDay,
      ),
    );
  }

  Future<void> _onSaveTask(_SaveTask event, Emitter<EditTaskState> emit) async {
    final result = taskId == null
        ? await taskInteractor.createTask(
            TaskEntity(
              title: event.title,
              description: event.description,
              date: state.selectedDate,
              createdAt: DateTime.now(),
            ),
          )
        : await taskInteractor.updateTask(
            TaskEntity(
              id: taskId,
              title: event.title,
              description: event.description,
              date: state.selectedDate,
              createdAt: _createdAt ?? DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
    Failure? failure;
    TaskEntity? savedTask;
    result.fold(
      ifLeft: (error) => failure = error,
      ifRight: (task) => savedTask = task,
    );
    if (failure != null) {
      TalkerService.instance.error(failure!.message);
      event.completer.completeError(failure!);
      return;
    }

    final resolvedTaskId = savedTask?.id ?? taskId;
    if (resolvedTaskId == null) {
      const error = ValidationFailure('Task id is required');
      TalkerService.instance.error(error.message);
      event.completer.completeError(error);
      return;
    }

    final syncResult = await _syncSubTasks(
      taskId: resolvedTaskId,
      subTasks: event.subTasks,
    );
    Failure? syncFailure;
    syncResult.fold(
      ifLeft: (error) => syncFailure = error,
      ifRight: (_) {},
    );
    if (syncFailure != null) {
      TalkerService.instance.error(syncFailure!.message);
      event.completer.completeError(syncFailure!);
      return;
    }

    event.completer.complete();
  }

  Future<void> _getTaskById({
    required int taskId,
    required Emitter<EditTaskState> emit,
  }) async {
    final result = await taskInteractor.getTaskById(taskId);

    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) {
        TalkerService.instance.info('Task: ${task.id}');
        _createdAt = task.createdAt;
        emit(
          state.copyWith(
            title: task.title,
            titleIsNotEmpty: task.title.trim().isNotEmpty,
            description: task.description ?? '',
            taskId: task.id,
            networkId: task.networkId,
            isCompleted: task.isCompleted,
            selectedDate: task.date,
            startTime: task.startTime,
            endTime: task.endTime,
            isAllDay: task.isAllDay,
          ),
        );
        _sideEffectController.add(
          EditTaskSideEffect.initEditTextControllers(
            task.title,
            task.description ?? '',
          ),
        );
      },
    );
  }

  Future<Either<Failure, void>> _syncSubTasks({
    required int taskId,
    required List<SubTaskUiModel> subTasks,
  }) async {
    final existingResult = await subTaskInteractor.getSubTasksByTaskId(taskId);
    Failure? failure;
    List<SubTaskEntity> existing = const [];
    existingResult.fold(
      ifLeft: (error) => failure = error,
      ifRight: (items) => existing = items,
    );
    if (failure != null) {
      return Left(failure!);
    }

    final existingIds =
        existing.where((item) => item.id != null).map((e) => e.id!).toSet();
    final incomingIds =
        subTasks.where((item) => item.id != null).map((e) => e.id!).toSet();

    final toDeleteIds = existingIds.difference(incomingIds).toList();
    final toUpdate = subTasks
        .where((item) => item.id != null && existingIds.contains(item.id))
        .map(
          (item) => SubTaskEntity(
            id: item.id,
            taskId: taskId,
            title: item.title,
            isCompleted: item.isCompleted,
          ),
        )
        .toList();
    final toInsert = subTasks
        .where((item) => item.id == null || !existingIds.contains(item.id))
        .map(
          (item) => SubTaskEntity(
            id: null,
            taskId: taskId,
            title: item.title,
            isCompleted: item.isCompleted,
          ),
        )
        .toList();

    if (toUpdate.isNotEmpty) {
      final updateResult = await subTaskInteractor.updateSubTasks(toUpdate);
      Failure? updateFailure;
      updateResult.fold(
        ifLeft: (error) => updateFailure = error,
        ifRight: (_) {},
      );
      if (updateFailure != null) {
        return Left(updateFailure!);
      }
    }

    if (toInsert.isNotEmpty) {
      final insertResult = await subTaskInteractor.insertSubTasks(toInsert);
      Failure? insertFailure;
      insertResult.fold(
        ifLeft: (error) => insertFailure = error,
        ifRight: (_) {},
      );
      if (insertFailure != null) {
        return Left(insertFailure!);
      }
    }

    if (toDeleteIds.isNotEmpty) {
      final deleteResult = await subTaskInteractor.removeSubTasks(toDeleteIds);
      Failure? deleteFailure;
      deleteResult.fold(
        ifLeft: (error) => deleteFailure = error,
        ifRight: (_) {},
      );
      if (deleteFailure != null) {
        return Left(deleteFailure!);
      }
    }

    return const Right(null);
  }
}
