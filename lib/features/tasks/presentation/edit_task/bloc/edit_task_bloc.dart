import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/features/tasks/data/models/task_duration_type.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/domain/models/sub_task_draft.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/save_edited_task_interactor.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_auto_save_controller.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_change_tracker.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_date_calculator.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_snapshots.dart';
import 'package:taskify/features/tasks/presentation/models/sub_task_model_ui.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';
part 'edit_task_side_effect.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState>
    with BlocSideEffectMixin<EditTaskBloc, EditTaskSideEffect> {
  final int? taskId;
  final TaskInteractor taskInteractor;
  final TagInteractor tagInteractor;
  final SaveEditedTaskInteractor saveEditedTaskInteractor;
  final EditTaskDateCalculator dateCalculator = const EditTaskDateCalculator();
  late final EditTaskChangeTracker _changeTracker;
  late final EditTaskAutoSaveController _autoSaveController;
  List<SubTaskModelUi> _pendingSubTasks = const [];
  bool _hasSubTasksSnapshot = false;
  bool _hasPendingAutoSave = false;

  final _sideEffectController = StreamController<EditTaskSideEffect>();
  @override
  Stream<EditTaskSideEffect> get sideEffects => _sideEffectController.stream;

  EditTaskBloc({
    required this.taskId,
    required this.taskInteractor,
    required this.tagInteractor,
    required this.saveEditedTaskInteractor,
  }) : super(EditTaskState(selectedDate: DateTime.now())) {
    _changeTracker = EditTaskChangeTracker(
      initialSelection: DateSelectionSnapshot(
        selectedDate: state.selectedDate,
        isAllDay: state.isAllDay,
        startTime: state.startTime,
        endTime: state.endTime,
      ),
      dateCalculator: dateCalculator,
    );
    _autoSaveController = EditTaskAutoSaveController(
      debounce: const Duration(seconds: 2),
      shouldSave: _shouldAutoSave,
      onTrigger: _triggerAutoSave,
    );
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
    on<EditTaskSubTasksChanged>(_onSubTasksChanged);
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
    _autoSaveController.enable();
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
    _scheduleAutoSave();
  }

  void _onDescriptionChanged(
    EditTaskDescriptionChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(description: event.description));
    _scheduleAutoSave();
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
        : dateCalculator.withDate(state.startTime!, event.date);
    final updatedEndTime = state.endTime == null
        ? null
        : dateCalculator.withDate(state.endTime!, event.date);
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
    final startTime = dateCalculator.combineDateAndTime(
      state.selectedDate,
      event.startTime,
    );
    final endTime = dateCalculator.combineDateAndTime(
      state.selectedDate,
      event.endTime,
    );
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
      selectedDate: _changeTracker.initialSelection.selectedDate,
      isAllDay: _changeTracker.initialSelection.isAllDay,
      startTime: _changeTracker.initialSelection.startTime,
      endTime: _changeTracker.initialSelection.endTime,
    );
  }

  void _onTagsUpdated(EditTaskTagsUpdated event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(selectedTags: event.tags));
    _scheduleAutoSave();
  }

  void _onRemoveTag(EditTaskRemoveTag event, Emitter<EditTaskState> emit) {
    emit(
      state.copyWith(
        selectedTags: state.selectedTags
            .where((tag) => tag.key != event.tag.key)
            .toList(),
      ),
    );
    _scheduleAutoSave();
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
    _autoSaveController.cancel();
    await _performSave(emit: emit, subTasks: event.subTasks, shouldClose: true);
  }

  Future<void> _onAutoSaveRequested(
    EditTaskAutoSaveRequested event,
    Emitter<EditTaskState> emit,
  ) async {
    _pendingSubTasks = event.subTasks;
    _hasSubTasksSnapshot = true;
    if (state.saveStatus == EditTaskSaveStatus.saving) {
      _scheduleAutoSave();
      return;
    }
    await _performSave(
      emit: emit,
      subTasks: event.subTasks,
      shouldClose: false,
    );
  }

  void _onSubTasksChanged(
    EditTaskSubTasksChanged event,
    Emitter<EditTaskState> _,
  ) {
    _pendingSubTasks = event.subTasks;
    _hasSubTasksSnapshot = true;
    if (event.shouldSchedule || _hasPendingAutoSave) {
      _hasPendingAutoSave = false;
      _scheduleAutoSave();
    }
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
        _changeTracker.updateAfterLoad(task: task, tags: tags);
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

  void _emitDateSelection(
    Emitter<EditTaskState> emit, {
    required DateTime selectedDate,
    required bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final resolvedTimes = dateCalculator.resolveTimes(
      selectedDate: selectedDate,
      isAllDay: isAllDay,
      startTime: startTime,
      endTime: endTime,
    );
    final currentSelection = DateSelectionSnapshot(
      selectedDate: selectedDate,
      isAllDay: isAllDay,
      startTime: resolvedTimes.startTime,
      endTime: resolvedTimes.endTime,
    );
    final isDateModified = _changeTracker.isDateModified(currentSelection);
    emit(
      state.copyWith(
        selectedDate: selectedDate,
        startTime: resolvedTimes.startTime,
        endTime: resolvedTimes.endTime,
        isAllDay: isAllDay,
        isDateModified: isDateModified,
      ),
    );
    _scheduleAutoSave();
  }

  EditTaskSnapshot _buildSnapshotFromState() {
    return EditTaskSnapshot(
      title: state.title,
      description: state.description,
      isCompleted: state.isCompleted,
      date: state.selectedDate,
      startTime: state.startTime,
      endTime: state.endTime,
      isAllDay: state.isAllDay,
    );
  }

  List<SubTaskSnapshot> _buildSubTaskSnapshots(List<SubTaskModelUi> subTasks) {
    return subTasks
        .map(
          (item) => SubTaskSnapshot(
            id: item.id,
            localKey: item.localKey,
            title: item.title,
            isCompleted: item.isCompleted,
          ),
        )
        .toList();
  }

  List<SubTaskDraft> _buildSubTaskDrafts(List<SubTaskModelUi> subTasks) {
    return subTasks
        .map(
          (item) => SubTaskDraft(
            id: item.id,
            title: item.title,
            isCompleted: item.isCompleted,
          ),
        )
        .toList();
  }

  bool _shouldAutoSave() {
    if (!_hasSubTasksSnapshot) {
      return false;
    }
    final snapshot = _buildSnapshotFromState();
    final subTaskSnapshots = _buildSubTaskSnapshots(_pendingSubTasks);
    return _changeTracker.shouldSave(
      snapshot: snapshot,
      tags: state.selectedTags,
      subTasks: subTaskSnapshots,
    );
  }

  void _triggerAutoSave() {
    add(EditTaskAutoSaveRequested(_pendingSubTasks));
  }

  void _scheduleAutoSave() {
    if (!_hasSubTasksSnapshot) {
      _hasPendingAutoSave = true;
      return;
    }
    _autoSaveController.scheduleSave();
  }

  Future<void> _performSave({
    required Emitter<EditTaskState> emit,
    required List<SubTaskModelUi> subTasks,
    required bool shouldClose,
  }) async {
    final snapshot = _buildSnapshotFromState();
    final subTaskSnapshots = _buildSubTaskSnapshots(subTasks);
    final shouldSave = _changeTracker.shouldSave(
      snapshot: snapshot,
      tags: state.selectedTags,
      subTasks: subTaskSnapshots,
    );
    if (!shouldSave) {
      if (shouldClose) {
        _sideEffectController.add(const EditTaskCloseScreen());
      }
      return;
    }

    emit(state.copyWith(saveStatus: EditTaskSaveStatus.saving));
    final shouldSyncTags = _changeTracker.areTagsChanged(state.selectedTags);
    final shouldUpsertTask =
        (taskId ?? state.taskId) == null ||
        _changeTracker.isTaskChanged(snapshot);
    final result = await saveEditedTaskInteractor.call(
      SaveEditedTaskParams(
        taskId: taskId ?? state.taskId,
        title: snapshot.title,
        description: snapshot.description,
        isCompleted: snapshot.isCompleted,
        selectedDate: snapshot.date,
        startTime: snapshot.startTime,
        endTime: snapshot.endTime,
        isAllDay: snapshot.isAllDay,
        createdAt: _changeTracker.createdAt,
        tags: state.selectedTags,
        subTasks: _buildSubTaskDrafts(subTasks),
        shouldSyncTags: shouldSyncTags,
        shouldUpsertTask: shouldUpsertTask,
      ),
    );

    result.fold(
      ifLeft: (failure) {
        emit(state.copyWith(saveStatus: EditTaskSaveStatus.error));
        TalkerService.instance.error('syncTag ${failure.message}');
      },
      ifRight: (result) {
        _changeTracker.updateAfterSave(
          savedTask: result.task,
          snapshot: snapshot,
          tags: state.selectedTags,
          subTasks: subTaskSnapshots,
        );
        emit(
          state.copyWith(
            saveStatus: EditTaskSaveStatus.saved,
            taskId: result.task.id ?? state.taskId,
            networkId: result.task.networkId ?? state.networkId,
          ),
        );
        if (shouldClose) {
          _sideEffectController.add(const EditTaskCloseScreen());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _autoSaveController.dispose();
    _sideEffectController.close();
    return super.close();
  }
}

