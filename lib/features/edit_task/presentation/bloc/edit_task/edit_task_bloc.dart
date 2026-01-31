import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/domain/tasks/models/task.dart';
import 'package:taskify/domain/tasks/models/task_duration_type.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';
part 'edit_task_side_effect.dart';

enum EditTaskSaveStatus { saving, saved, error }

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState>
    with BlocSideEffectMixin<EditTaskBloc, EditTaskSideEffect> {
  static const _defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const _defaultEndTime = TimeOfDay(hour: 10, minute: 0);

  final int? taskId;
  final TaskInteractor taskInteractor;
  final SubTaskInteractor subTaskInteractor;
  final TagInteractor tagInteractor;
  DateTime? _createdAt;
  _TaskSnapshot? _lastSavedTaskSnapshot;
  List<String> _lastSavedTagKeys = const [];
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
    on<EditTaskStarted>(_onStarted);
    on<EditTaskTitleChanged>(_onTitleChanged);
    on<EditTaskDescriptionChanged>(_onDescriptionChanged);
    on<EditTaskSelectDate>(_onSelectDate);
    on<EditTaskDateSelected>(_onDateSelected);
    on<EditTaskDurationTypeSelected>(_onDurationTypeSelected);
    on<EditTaskTimeRangeSelected>(_onTimeRangeSelected);
    on<EditTaskDateSelectionCleared>(_onDateSelectionCleared);
    on<EditTaskTagsUpdated>(_onTagsUpdated);
    on<EditTaskSaveTask>(_onSaveTask);
    on<EditTaskAutoSaveRequested>(_onAutoSaveRequested);
    on<EditTaskRemoveTag>(_onRemoveTag);
    on<TryTaskRemove>(_onTryTaskRemove);
  }

  Future<void> _onStarted(
    EditTaskStarted event,
    Emitter<EditTaskState> emit,
  ) async {
    if (taskId != null) {
      await _getTaskById(taskId: taskId!, emit: emit);
    }
  }

  void _onTitleChanged(
    EditTaskTitleChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title,
        titleIsNotEmpty: event.title.trim().isNotEmpty,
      ),
    );
  }

  void _onDescriptionChanged(
    EditTaskDescriptionChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onSelectDate(EditTaskSelectDate event, Emitter<EditTaskState> emit) {
    _emitDateSelection(
      emit,
      selectedDate: event.date,
      isAllDay: event.isAllDay,
      startTime: event.startTime,
      endTime: event.endTime,
    );
  }

  void _onDateSelected(
    EditTaskDateSelected event,
    Emitter<EditTaskState> emit,
  ) {
    final updatedStartTime = state.startTime == null
        ? null
        : _withDate(state.startTime!, event.date);
    final updatedEndTime = state.endTime == null
        ? null
        : _withDate(state.endTime!, event.date);
    _emitDateSelection(
      emit,
      selectedDate: event.date,
      isAllDay: state.isAllDay,
      startTime: updatedStartTime,
      endTime: updatedEndTime,
    );
  }

  void _onDurationTypeSelected(
    EditTaskDurationTypeSelected event,
    Emitter<EditTaskState> emit,
  ) {
    final isAllDay = event.type == TaskDurationType.allDay;
    _emitDateSelection(
      emit,
      selectedDate: state.selectedDate,
      isAllDay: isAllDay,
      startTime: state.startTime,
      endTime: state.endTime,
    );
  }

  void _onTimeRangeSelected(
    EditTaskTimeRangeSelected event,
    Emitter<EditTaskState> emit,
  ) {
    final startTime = _combineDateAndTime(state.selectedDate, event.startTime);
    final endTime = _combineDateAndTime(state.selectedDate, event.endTime);
    _emitDateSelection(
      emit,
      selectedDate: state.selectedDate,
      isAllDay: false,
      startTime: startTime,
      endTime: endTime,
    );
  }

  void _onDateSelectionCleared(
    EditTaskDateSelectionCleared event,
    Emitter<EditTaskState> emit,
  ) {
    _emitDateSelection(
      emit,
      selectedDate: _initialSelection.selectedDate,
      isAllDay: _initialSelection.isAllDay,
      startTime: _initialSelection.startTime,
      endTime: _initialSelection.endTime,
    );
  }

  void _onTagsUpdated(EditTaskTagsUpdated event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(selectedTags: event.tags));
  }

  void _onRemoveTag(EditTaskRemoveTag event, Emitter<EditTaskState> emit) {
    emit(
      state.copyWith(
        selectedTags: state.selectedTags
            .where((tag) => tag.key != event.tag.key)
            .toList(),
      ),
    );
  }

  void _onTryTaskRemove(
    TryTaskRemove event,
    Emitter<EditTaskState> emit,
  ) async {
    _sideEffectController.add(const EditTaskShowConfirmationDialog());
  }

  Future<void> _onSaveTask(
    EditTaskSaveTask event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(saveStatus: EditTaskSaveStatus.saving));
    final result = await _saveTask(
      title: event.title,
      description: event.description,
      subTasks: event.subTasks,
    );
    result.fold(
      ifLeft: (failure) {
        emit(state.copyWith(saveStatus: EditTaskSaveStatus.error));
        TalkerService.instance.error('syncTag ${failure.message}');
      },
      ifRight: (task) {
        emit(
          state.copyWith(
            saveStatus: EditTaskSaveStatus.saved,
            taskId: task.id ?? state.taskId,
            networkId: task.networkId ?? state.networkId,
          ),
        );
        _sideEffectController.add(const EditTaskCloseScreen());
      },
    );
  }

  Future<void> _onAutoSaveRequested(
    EditTaskAutoSaveRequested event,
    Emitter<EditTaskState> emit,
  ) async {
    if (state.saveStatus == EditTaskSaveStatus.saving) {
      return;
    }
    emit(state.copyWith(saveStatus: EditTaskSaveStatus.saving));
    final result = await _saveTask(
      title: state.title,
      description: state.description,
      subTasks: event.subTasks,
    );
    result.fold(
      ifLeft: (failure) {
        emit(state.copyWith(saveStatus: EditTaskSaveStatus.error));
        TalkerService.instance.error('syncTag ${failure.message}');
      },
      ifRight: (task) {
        emit(
          state.copyWith(
            saveStatus: EditTaskSaveStatus.saved,
            taskId: task.id ?? state.taskId,
            networkId: task.networkId ?? state.networkId,
          ),
        );
      },
    );
  }

  Future<void> _getTaskById({
    required int taskId,
    required Emitter<EditTaskState> emit,
  }) async {
    final result = await taskInteractor.getTaskById(taskId);
    final tagsResult = await tagInteractor.getTaskTags(taskId);
    List<TagEntity> tags = const [];
    tagsResult.fold(
      ifLeft: (error) =>
          TalkerService.instance.error('syncTag ${error.message}'),
      ifRight: (items) {
        TalkerService.instance.info('syncTag Tags: ${items.length}');
        tags = items;
      },
    );

    result.fold(
      ifLeft: (failure) =>
          TalkerService.instance.error('syncTag ${failure.message}'),
      ifRight: (task) {
        TalkerService.instance.info('syncTag Task: ${task.id}');
        _createdAt = task.createdAt;
        _lastSavedTaskSnapshot = _TaskSnapshot.fromTask(task);
        _lastSavedTagKeys = _sortedTagKeys(tags);
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
          EditTaskInitEditTextControllers(task.title, task.description ?? ''),
        );
      },
    );
  }

  Future<Either<Failure, void>> _syncSubTasks({
    required int taskId,
    required List<SubTaskUiModel> subTasks,
  }) async {
    final normalizedSubTasks = subTasks
        .where((item) => item.title.trim().isNotEmpty)
        .toList();
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

    final existingById = <int, SubTaskEntity>{};
    for (final item in existing) {
      if (item.id != null) {
        existingById[item.id!] = item;
      }
    }
    final existingIds = existingById.keys.toSet();
    final incomingIds = normalizedSubTasks
        .where((item) => item.id != null)
        .map((e) => e.id!)
        .toSet();

    final toDeleteIds = existingIds.difference(incomingIds).toList();
    final toUpdate = <SubTaskEntity>[];
    for (final item in normalizedSubTasks) {
      final id = item.id;
      if (id == null || !existingIds.contains(id)) {
        continue;
      }
      final existingItem = existingById[id];
      if (existingItem == null) {
        continue;
      }
      if (existingItem.title == item.title &&
          existingItem.isCompleted == item.isCompleted) {
        continue;
      }
      toUpdate.add(
        SubTaskEntity(
          id: id,
          taskId: taskId,
          title: item.title,
          isCompleted: item.isCompleted,
        ),
      );
    }
    final toInsert = normalizedSubTasks
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

  Future<Either<Failure, TaskEntity>> _saveTask({
    required String title,
    required String description,
    required List<SubTaskUiModel> subTasks,
  }) async {
    final resolvedTaskId = taskId ?? state.taskId;
    final currentSnapshot = _TaskSnapshot.fromValues(
      title: title,
      description: description,
      isCompleted: state.isCompleted,
      date: state.selectedDate,
      startTime: state.startTime,
      endTime: state.endTime,
      isAllDay: state.isAllDay,
    );
    final shouldUpdateTask =
        resolvedTaskId == null || _lastSavedTaskSnapshot != currentSnapshot;

    Failure? failure;
    TaskEntity? savedTask;
    if (shouldUpdateTask) {
      final result = resolvedTaskId == null
          ? await taskInteractor.createTask(
              TaskEntity(
                title: title,
                description: description,
                date: state.selectedDate,
                createdAt: DateTime.now(),
              ),
            )
          : await taskInteractor.updateTask(
              TaskEntity(
                id: resolvedTaskId,
                title: title,
                description: description,
                date: state.selectedDate,
                createdAt: _createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
      result.fold(
        ifLeft: (error) => failure = error,
        ifRight: (task) => savedTask = task,
      );
      if (failure != null) {
        return Left(failure!);
      }
    }

    final saved = savedTask;
    final taskIdResolved = saved?.id ?? resolvedTaskId;
    if (taskIdResolved == null) {
      return const Left(ValidationFailure('Task id is required'));
    }
    _createdAt = saved?.createdAt ?? _createdAt;
    _lastSavedTaskSnapshot = currentSnapshot;

    final syncResult = await _syncSubTasks(
      taskId: taskIdResolved,
      subTasks: subTasks,
    );
    Failure? syncFailure;
    syncResult.fold(ifLeft: (error) => syncFailure = error, ifRight: (_) {});
    if (syncFailure != null) {
      return Left(syncFailure!);
    }

    final currentTagKeys = _sortedTagKeys(state.selectedTags);
    if (!_areTagKeysEqual(_lastSavedTagKeys, currentTagKeys)) {
      final tagResult = await tagInteractor.setTaskTags(
        taskIdResolved,
        state.selectedTags,
      );
      Failure? tagFailure;
      tagResult.fold(ifLeft: (error) => tagFailure = error, ifRight: (_) {});
      if (tagFailure != null) {
        return Left(tagFailure!);
      }
      _lastSavedTagKeys = currentTagKeys;
    }

    if (saved != null) {
      return Right(saved);
    }
    return Right(
      TaskEntity(
        id: taskIdResolved,
        title: title,
        description: description,
        date: state.selectedDate,
        createdAt: _createdAt ?? DateTime.now(),
        updatedAt: shouldUpdateTask ? DateTime.now() : null,
      ),
    );
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

  void _emitDateSelection(
    Emitter<EditTaskState> emit, {
    required DateTime selectedDate,
    required bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final resolvedTimes = _resolveTimes(
      selectedDate: selectedDate,
      isAllDay: isAllDay,
      startTime: startTime,
      endTime: endTime,
    );
    final isDateModified = _isDateModified(
      selectedDate: selectedDate,
      isAllDay: isAllDay,
      startTime: resolvedTimes.startTime,
      endTime: resolvedTimes.endTime,
    );
    emit(
      state.copyWith(
        selectedDate: selectedDate,
        startTime: resolvedTimes.startTime,
        endTime: resolvedTimes.endTime,
        isAllDay: isAllDay,
        isDateModified: isDateModified,
      ),
    );
  }

  _ResolvedTimes _resolveTimes({
    required DateTime selectedDate,
    required bool isAllDay,
    required DateTime? startTime,
    required DateTime? endTime,
  }) {
    if (isAllDay) {
      return const _ResolvedTimes();
    }
    final resolvedStart = _normalizeTime(
      selectedDate,
      startTime ?? _combineDateAndTime(selectedDate, _defaultStartTime),
    );
    final resolvedEnd = _normalizeTime(
      selectedDate,
      endTime ?? _combineDateAndTime(selectedDate, _defaultEndTime),
    );
    return _ResolvedTimes(startTime: resolvedStart, endTime: resolvedEnd);
  }

  DateTime _withDate(DateTime source, DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      source.hour,
      source.minute,
    );
  }

  DateTime _normalizeTime(DateTime date, DateTime source) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      source.hour,
      source.minute,
    );
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  List<String> _sortedTagKeys(List<TagEntity> tags) {
    final keys = tags.map((tag) => tag.key).toList()..sort();
    return keys;
  }

  bool _areTagKeysEqual(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var i = 0; i < left.length; i += 1) {
      if (left[i] != right[i]) {
        return false;
      }
    }
    return true;
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

class _ResolvedTimes {
  const _ResolvedTimes({this.startTime, this.endTime});

  final DateTime? startTime;
  final DateTime? endTime;
}

class _TaskSnapshot extends Equatable {
  const _TaskSnapshot({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
  });

  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;

  factory _TaskSnapshot.fromTask(TaskEntity task) {
    return _TaskSnapshot(
      title: task.title,
      description: task.description ?? '',
      isCompleted: task.isCompleted,
      date: task.date,
      startTime: task.startTime,
      endTime: task.endTime,
      isAllDay: task.isAllDay,
    );
  }

  factory _TaskSnapshot.fromValues({
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime date,
    required DateTime? startTime,
    required DateTime? endTime,
    required bool isAllDay,
  }) {
    return _TaskSnapshot(
      title: title,
      description: description,
      isCompleted: isCompleted,
      date: date,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    isCompleted,
    date,
    startTime,
    endTime,
    isAllDay,
  ];
}
