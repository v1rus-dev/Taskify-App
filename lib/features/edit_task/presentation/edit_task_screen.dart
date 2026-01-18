import 'dart:async';

import 'package:animated_visibility/animated_visibility.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_bottom_part.dart';
import 'package:taskify/features/edit_task/presentation/widgets/sub_task_part.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task_bloc.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key, required this.taskId});
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTaskBloc(
        taskId: taskId,
        taskInteractor: locator<TaskInteractor>(),
        subTaskInteractor: locator<SubTaskInteractor>(),
      )..add(const EditTaskEvent.started()),
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
  void initState() {
    super.initState();

    // ref.listenManual<EditTaskState>(editTaskNotifierProvider(widget.taskId), (
    //   previous,
    //   next,
    // ) {
    //   if (next.title.isNotEmpty && titleController.text != next.title) {
    //     final selection = titleController.selection;
    //     titleController.value = titleController.value.copyWith(
    //       text: next.title,
    //       selection: _clampSelection(selection, next.title),
    //       composing: TextRange.empty,
    //     );
    //   }

    //   if (next.description.isNotEmpty &&
    //       descriptionController.text != next.description) {
    //     final selection = descriptionController.selection;
    //     descriptionController.value = descriptionController.value.copyWith(
    //       text: next.description,
    //       selection: _clampSelection(selection, next.description),
    //       composing: TextRange.empty,
    //     );
    //   }
    // });
  }

  static TextSelection _clampSelection(TextSelection selection, String text) {
    final max = text.length;
    final base = selection.baseOffset.clamp(0, max);
    final extent = selection.extentOffset.clamp(0, max);
    return TextSelection(baseOffset: base, extentOffset: extent);
  }

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
      ),
    );

    try {
      await completer.future;
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (_) {
      // тут можно показать snackbar/диалог, но ты просил без лишнего
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
    final mq = MediaQuery.of(context);
    final keyboardBottom = mq.viewInsets.bottom;
    final safeBottom = mq.padding.bottom;
    final bottomInset = keyboardBottom > 0 ? keyboardBottom : safeBottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: EditTaskAppBar(taskId: widget.taskId),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: EditTaskBottomPart(
          onSavePressed: () => _saveTask(context: context),
          onDateSelected: (d, isAllDay, start, end) {
            context.read<EditTaskBloc>().add(
              EditTaskEvent.selectDate(d, isAllDay, start, end),
            );
          },
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    hintText: AppLocalizations.of(context)?.writeANewTask ?? '',
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    hintStyle: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColorExtensions.getTextSecondaryColor(context),
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
                                color: AppColorExtensions.getTextSecondaryColor(
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
    );
  }
}
