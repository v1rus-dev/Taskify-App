import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/save_edited_task_interactor.dart';
import 'package:taskify/features/tasks/presentation/edit_task/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/tasks/presentation/edit_task/widgets/edit_task_description_card.dart';
import 'package:taskify/features/tasks/presentation/edit_task/widgets/edit_task_date_period_card.dart';
import 'package:taskify/features/tasks/presentation/edit_task/widgets/edit_task_sub_tasks_slivers.dart';
import 'package:taskify/features/tasks/presentation/edit_task/widgets/edit_task_tags_card.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/tasks/presentation/edit_task/bloc/edit_task_bloc.dart';
import 'package:taskify/features/tasks/presentation/edit_sub_task/bloc/edit_sub_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key, required this.taskId});
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditTaskBloc(
            taskId: taskId,
            taskInteractor: locator<TaskInteractor>(),
            tagInteractor: locator<TagInteractor>(),
            saveEditedTaskInteractor: locator<SaveEditedTaskInteractor>(),
          )..add(const EditTaskStarted()),
        ),
        BlocProvider(
          create: (context) => EditSubTaskBloc(
            taskId: taskId,
            subTaskInteractor: locator<SubTaskInteractor>(),
          )..add(const EditSubTaskStarted()),
        ),
      ],
      child: EditTaskScreen(taskId: taskId),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, this.taskId});
  final int? taskId;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final scrollController = ScrollController();
  bool _isEditTaskInitialized = false;
  bool _isSubTasksInitialized = false;
  _EditTaskSnapshot? _snapshotState;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isEditTaskInitialized = widget.taskId == null;
    _isSubTasksInitialized = widget.taskId == null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureSnapshotIfNeeded();
    });
  }

  void _onTitleChanged(String value) {
    context.read<EditTaskBloc>().add(EditTaskTitleChanged(value));
  }

  void _onDescriptionChanged(String value) {
    context.read<EditTaskBloc>().add(EditTaskDescriptionChanged(value));
  }

  Future<void> _onClosePressed() async {
    if (!_shouldSaveTask()) {
      if (mounted) {
        context.pop();
      }
      return;
    }
    final editBloc = context.read<EditTaskBloc>();
    final subTasks = context.read<EditSubTaskBloc>().state.subTasks;
    editBloc.add(
      EditTaskSaveTask(
        titleController.text,
        descriptionController.text,
        subTasks,
      ),
    );
  }

  void _onSubTasksChanged(BuildContext context, EditSubTaskState state) {
    if (!_isSubTasksInitialized) {
      _isSubTasksInitialized = true;
      _captureSnapshotIfNeeded();
      context.read<EditTaskBloc>().add(
        EditTaskSubTasksChanged(state.subTasks, shouldSchedule: false),
      );
      return;
    }
    context.read<EditTaskBloc>().add(EditTaskSubTasksChanged(state.subTasks));
  }

  void _onSideEffect(BuildContext context, EditTaskSideEffect effect) {
    switch (effect) {
      case EditTaskInitEditTextControllers():
        titleController.text = effect.title;
        descriptionController.text = effect.description;
        _isEditTaskInitialized = true;
        _captureSnapshotIfNeeded();
        break;
      case EditTaskCloseScreen():
        context.pop();
        break;
    }
  }

  void _onSaveStatusChanged(BuildContext context, EditTaskState state) {
    if (state.saveStatus == EditTaskSaveStatus.saved) {
      _updateSnapshot();
    }
  }

  void _captureSnapshotIfNeeded() {
    if (_snapshotState != null) {
      return;
    }
    if (!_isEditTaskInitialized || !_isSubTasksInitialized) {
      return;
    }
    _snapshotState = _buildSnapshot();
  }

  void _updateSnapshot() {
    if (!_isEditTaskInitialized || !_isSubTasksInitialized) {
      return;
    }
    _snapshotState = _buildSnapshot();
  }

  bool _shouldSaveTask() {
    final currentSnapshot = _buildSnapshot();
    if (currentSnapshot.isEmpty || currentSnapshot.title.trim().isEmpty) {
      return false;
    }
    final existingSnapshot = _snapshotState;
    if (existingSnapshot == null) {
      return true;
    }
    return existingSnapshot != currentSnapshot;
  }

  _EditTaskSnapshot _buildSnapshot() {
    final editState = context.read<EditTaskBloc>().state;
    final subTasks = context.read<EditSubTaskBloc>().state.subTasks;
    final tagKeys = editState.selectedTags.map((tag) => tag.key).toList()
      ..sort();
    return _EditTaskSnapshot(
      title: editState.title,
      description: editState.description,
      isCompleted: editState.isCompleted,
      selectedDate: editState.selectedDate,
      startTime: editState.startTime,
      endTime: editState.endTime,
      isAllDay: editState.isAllDay,
      tagKeys: tagKeys,
      subTasks: subTasks
          .map(
            (item) => _SubTaskSnapshot(
              id: item.id,
              localKey: item.localKey,
              title: item.title,
              isCompleted: item.isCompleted,
            ),
          )
          .toList(),
    );
  }

  Widget _buildTitleTextField() {
    final theme = Theme.of(context);
    return TextField(
      controller: titleController,
      maxLines: null,
      maxLength: 70,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onChanged: _onTitleChanged,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColorExtensions.getTextPrimaryColor(context),
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)?.writeANewTask ?? '',
        border: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        counterText: '',
        hintStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColorExtensions.getTextSecondaryColor(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditTaskBloc, EditTaskState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus,
          listener: _onSaveStatusChanged,
        ),
        BlocListener<EditSubTaskBloc, EditSubTaskState>(
          listenWhen: (previous, current) =>
              previous.subTasks != current.subTasks,
          listener: _onSubTasksChanged,
        ),
      ],
      child: BlocSideEffectListener<EditTaskBloc, EditTaskSideEffect>(
        listener: (effect) => _onSideEffect(context, effect),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            await _onClosePressed();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColorExtensions.getBackgroundColor(context),
            appBar: EditTaskAppBar(
              taskId: widget.taskId,
              onClose: _onClosePressed,
            ),
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                const SliverGap(20),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(child: _buildTitleTextField()),
                ),
                const SliverGap(12),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: EditTaskDescriptionCard(
                      descriptionController: descriptionController,
                      onChanged: _onDescriptionChanged,
                    ),
                  ),
                ),
                const SliverGap(12),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(child: EditTaskDatePeriodCard()),
                ),
                const SliverGap(12),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(child: EditTaskTagsCard()),
                ),
                const SliverGap(12),
                const EditTaskSubTasksSlivers(),
                const SliverGap(12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditTaskSnapshot extends Equatable {
  const _EditTaskSnapshot({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.tagKeys,
    required this.subTasks,
  });

  final String title;
  final String description;
  final bool isCompleted;
  final DateTime selectedDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final List<String> tagKeys;
  final List<_SubTaskSnapshot> subTasks;

  bool get isEmpty {
    if (title.trim().isNotEmpty) {
      return false;
    }
    if (description.trim().isNotEmpty) {
      return false;
    }
    if (tagKeys.isNotEmpty) {
      return false;
    }
    return subTasks.every((item) => item.title.trim().isEmpty);
  }

  @override
  List<Object?> get props => [
    title,
    description,
    isCompleted,
    selectedDate,
    startTime,
    endTime,
    isAllDay,
    tagKeys,
    subTasks,
  ];
}

class _SubTaskSnapshot extends Equatable {
  const _SubTaskSnapshot({
    required this.id,
    required this.localKey,
    required this.title,
    required this.isCompleted,
  });

  final int? id;
  final int localKey;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, localKey, title, isCompleted];
}
