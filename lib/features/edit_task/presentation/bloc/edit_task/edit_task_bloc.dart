import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/domain/entities/sub_task.dart';
import 'package:taskify/domain/entities/tag.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
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
  final TagInteractor tagInteractor;
  DateTime? _createdAt;
  late _DateSelectionSnapshot _initialSelection;

  final _sideEffectController = StreamController<EditTaskSideEffect>();
  @override
  Stream<EditTaskSideEffect> get sideEffects => _sideEffectController.stream;

  EditTaskBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.subTaskInteractor,
    required this.tagInteractor,
  }) : super(EditTaskState(selectedDate: DateTime.now())) {
    _initialSelection = _DateSelectionSnapshot.fromState(state);
    on<_Started>(_onStarted);
    on<_TitleChanged>(_onTitleChanged);
    on<_SelectDate>(_onSelectDate);
    on<_TagsUpdated>(_onTagsUpdated);
    on<_SaveTask>(_onSaveTask);
    on<_RemoveTag>(_onRemoveTag);
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
    final isDateModified = _isDateModified(
      selectedDate: event.date,
      isAllDay: event.isAllDay,
      startTime: resolvedStartTime,
      endTime: resolvedEndTime,
    );
    emit(
      state.copyWith(
        selectedDate: event.date,
        startTime: resolvedStartTime,
        endTime: resolvedEndTime,
        isAllDay: event.isAllDay,
        isDateModified: isDateModified,
      ),
    );
  }

  void _onTagsUpdated(_TagsUpdated event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(selectedTags: event.tags));
  }

  void _onRemoveTag(_RemoveTag event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(selectedTags: state.selectedTags.where((tag) => tag.id != event.tag.id).toList()));
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

    final tagResult = await tagInteractor.setTaskTags(
      resolvedTaskId,
      state.selectedTags,
    );
    Failure? tagFailure;
    tagResult.fold(
      ifLeft: (error) => tagFailure = error,
      ifRight: (_) {},
    );
    if (tagFailure != null) {
      TalkerService.instance.error(tagFailure!.message);
      event.completer.completeError(tagFailure!);
      return;
    }

    event.completer.complete();
  }

  Future<void> _getTaskById({
    required int taskId,
    required Emitter<EditTaskState> emit,
  }) async {
    final result = await taskInteractor.getTaskById(taskId);
    final tagsResult = await tagInteractor.getTaskTags(taskId);
    List<TagEntity> tags = const [];
    tagsResult.fold(
      ifLeft: (error) => TalkerService.instance.error(error.message),
      ifRight: (items) {
        TalkerService.instance.info('Tags: ${items.length}');
        tags = items;
      },
    );

    result.fold(
      ifLeft: (failure) => TalkerService.instance.error(failure.message),
      ifRight: (task) {
        TalkerService.instance.info('Task: ${task.id}');
        _createdAt = task.createdAt;
        _initialSelection = _DateSelectionSnapshot(
          selectedDate: task.date,
          isAllDay: task.isAllDay,
          startTime: task.startTime,
          endTime: task.endTime,
        );
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
            isDateModified: false,
            selectedTags: tags,
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

  bool _isDateModified({
    required DateTime selectedDate,
    required bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    if (!_isSameDay(selectedDate, _initialSelection.selectedDate)) {
      return true;
    }
    if (isAllDay != _initialSelection.isAllDay) {
      return true;
    }
    if (!_isSameTimeOfDay(startTime, _initialSelection.startTime)) {
      return true;
    }
    if (!_isSameTimeOfDay(endTime, _initialSelection.endTime)) {
      return true;
    }
    return false;
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool _isSameTimeOfDay(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return true;
    }
    if (left == null || right == null) {
      return false;
    }
    return left.hour == right.hour && left.minute == right.minute;
  }
}

class _DateSelectionSnapshot {
  const _DateSelectionSnapshot({
    required this.selectedDate,
    required this.isAllDay,
    this.startTime,
    this.endTime,
  });

  final DateTime selectedDate;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;

  factory _DateSelectionSnapshot.fromState(EditTaskState state) {
    return _DateSelectionSnapshot(
      selectedDate: state.selectedDate,
      isAllDay: state.isAllDay,
      startTime: state.startTime,
      endTime: state.endTime,
    );
  }
}
