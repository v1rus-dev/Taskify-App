import 'dart:async';

import 'package:animated_visibility/animated_visibility.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:keyboard_safe/keyboard_safe.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_bottom_part.dart';
import 'package:taskify/features/edit_task/presentation/widgets/sub_task_part.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_sub_task/edit_sub_task_bloc.dart';

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
          )..add(const EditTaskEvent.started()),
        ),
        BlocProvider(
          create: (context) => EditSubTaskBloc(
            taskId: taskId,
            subTaskInteractor: locator<SubTaskInteractor>(),
          )..add(const EditSubTaskEvent.started()),
        ),
      ],
      child: const EditTaskScreen(),
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
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveTask({required BuildContext context}) async {
    final completer = Completer<void>();

    context.read<EditTaskBloc>().add(
      EditTaskEvent.saveTask(
        completer,
        titleController.text,
        descriptionController.text,
        context.read<EditSubTaskBloc>().state.subTasks,
      ),
    );

    try {
      await completer.future;
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!context.mounted) return;
    }
  }

  void _onTitleSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      descriptionFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSideEffectListener<EditTaskBloc, EditTaskSideEffect>(
      bloc: context.read<EditTaskBloc>(),
      listener: (context, effect) {
        effect.when(
          showLoadingDialog: () {},
          initEditTextControllers: (title, description) {
            titleController.text = title;
            descriptionController.text = description;
          },
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: EditTaskAppBar(taskId: widget.taskId),
        bottomNavigationBar: KeyboardSafe(
          scroll: true,
          autoScrollToFocused: true,
          dismissOnTapOutside: true,
          safeArea: true,
          keyboardAnimationDuration: const Duration(milliseconds: 120),
          child: EditTaskBottomPart(
            onSavePressed: () => _saveTask(context: context),
          ),
        ),

        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    TextField(
                      controller: titleController,
                      focusNode: titleFocusNode,
                      maxLines: null,
                      maxLength: 155,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColorExtensions.getTextPrimaryColor(context),
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: _onTitleSubmitted,
                      onChanged: (value) => context.read<EditTaskBloc>().add(
                        EditTaskEvent.titleChanged(value),
                      ),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)?.writeANewTask ?? '',
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintStyle: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColorExtensions.getTextSecondaryColor(
                            context,
                          ),
                        ),
                      ),
                    ),
                
                    BlocBuilder<EditTaskBloc, EditTaskState>(
                      builder: (context, state) {
                        return AnimatedVisibility(
                          visible: state.titleIsNotEmpty,
                          enter: fadeIn(curve: Curves.easeIn),
                          exit: fadeOut(curve: Curves.easeOut),
                          child: Column(
                            key: const ValueKey('desc_fields_shown'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(24),
                
                              TextField(
                                controller: descriptionController,
                                focusNode: descriptionFocusNode,
                                maxLines: null,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 20,
                                  color: AppColorExtensions.getTextPrimaryColor(
                                    context,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)?.description ??
                                      '',
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 20,
                                    color:
                                        AppColorExtensions.getTextSecondaryColor(
                                          context,
                                        ),
                                  ),
                                ),
                              ),
                              const Gap(24),
                              SubTaskPart(),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
