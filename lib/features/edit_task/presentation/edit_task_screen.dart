import 'dart:async';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_description_card.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_date_period_card.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_sub_tasks_slivers.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_tags_card.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_sub_task/edit_sub_task_bloc.dart';
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
            subTaskInteractor: locator<SubTaskInteractor>(),
            tagInteractor: locator<TagInteractor>(),
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
  Timer? _subTasksAutoSaveTimer;
  bool _isEditTaskInitialized = false;
  bool _isSubTasksInitialized = false;

  @override
  void dispose() {
    _subTasksAutoSaveTimer?.cancel();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isEditTaskInitialized = widget.taskId == null;
    _isSubTasksInitialized = widget.taskId == null;
  }

  void _onTitleChanged(String value) {
    context.read<EditTaskBloc>().add(EditTaskTitleChanged(value));
  }

  void _onDescriptionChanged(String value) {
    context.read<EditTaskBloc>().add(EditTaskDescriptionChanged(value));
  }

  Future<void> _onClosePressed() async {
    final completer = Completer<void>();
    final editBloc = context.read<EditTaskBloc>();
    final subTasks = context.read<EditSubTaskBloc>().state.subTasks;
    editBloc.add(
      EditTaskSaveTask(
        completer,
        titleController.text,
        descriptionController.text,
        subTasks,
      ),
    );
    try {
      await completer.future;
    } catch (_) {}
    if (!mounted) {
      return;
    }
    context.pop();
  }

  void _onAutoSaveRequested() {
    if (!_isEditTaskInitialized) {
      return;
    }
    final editBloc = context.read<EditTaskBloc>();
    final subTasks = context.read<EditSubTaskBloc>().state.subTasks;
    editBloc.add(EditTaskAutoSaveRequested(subTasks));
  }

  void _onEditTaskChanged(BuildContext context, EditTaskState state) {
    if (!_isEditTaskInitialized) {
      _isEditTaskInitialized = true;
      return;
    }
    _onAutoSaveRequested();
  }

  void _onSubTasksChanged(BuildContext context, EditSubTaskState state) {
    if (!_isSubTasksInitialized) {
      _isSubTasksInitialized = true;
      return;
    }
    _scheduleSubTasksAutoSave();
  }

  void _scheduleSubTasksAutoSave() {
    if (!_isEditTaskInitialized) {
      return;
    }
    final subTasks = context.read<EditSubTaskBloc>().state.subTasks;
    final hasEmpty = subTasks.any((item) => item.title.trim().isEmpty);
    if (hasEmpty) {
      _subTasksAutoSaveTimer?.cancel();
      return;
    }
    _subTasksAutoSaveTimer?.cancel();
    _subTasksAutoSaveTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) {
        return;
      }
      _onAutoSaveRequested();
    });
  }

  void _onSideEffect(EditTaskSideEffect effect) {
    if (effect is EditTaskInitEditTextControllers) {
      titleController.text = effect.title;
      descriptionController.text = effect.description;
      _isEditTaskInitialized = true;
    }
  }

  bool _shouldAutoSave(EditTaskState previous, EditTaskState current) {
    return previous.title != current.title ||
        previous.description != current.description ||
        previous.selectedDate != current.selectedDate ||
        previous.startTime != current.startTime ||
        previous.endTime != current.endTime ||
        previous.isAllDay != current.isAllDay ||
        previous.selectedTags != current.selectedTags;
  }

  Widget _buildTitleTextField() {
    final theme = Theme.of(context);
    return TextField(
      controller: titleController,
      maxLines: null,
      maxLength: 155,
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
          listenWhen: _shouldAutoSave,
          listener: _onEditTaskChanged,
        ),
        BlocListener<EditSubTaskBloc, EditSubTaskState>(
          listenWhen: (previous, current) =>
              previous.subTasks != current.subTasks,
          listener: _onSubTasksChanged,
        ),
      ],
      child: BlocSideEffectListener<EditTaskBloc, EditTaskSideEffect>(
        listener: _onSideEffect,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              await _onClosePressed();
            }
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
