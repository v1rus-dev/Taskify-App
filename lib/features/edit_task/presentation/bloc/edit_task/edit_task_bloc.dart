import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/features/edit_task/presentation/models/sub_task_ui_model.dart';
import 'dart:async';

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
  List<int> _initialSubTaskIds = const [];

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
    result.fold(
      ifLeft: (failure) {
        TalkerService.instance.error(failure.message);
        event.completer.completeError(failure);
      },
      ifRight: (task) {
        event.completer.complete();
      },
    );
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
}
