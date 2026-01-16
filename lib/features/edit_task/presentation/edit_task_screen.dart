import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_notifier.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_state.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_bottom_part.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  const EditTaskScreen({super.key, this.taskId});

  final int? taskId;

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveTask({
    required EditTaskNotifier notifier,
    required BuildContext context,
  }) async {
    final completer = Completer<void>();

    notifier.onSaveTask(
      title: titleController.text,
      description: descriptionController.text,
      completer: completer,
    );

    try {
      await completer.future;

      if (!context.mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editTaskNotifierProvider(widget.taskId));
    final notifier = ref.read(editTaskNotifierProvider(widget.taskId).notifier);

    if (state.title.isNotEmpty && titleController.text.isEmpty) {
      titleController.text = state.title;
    }
    if (state.description.isNotEmpty && descriptionController.text.isEmpty) {
      descriptionController.text = state.description;
    }

    ref.listen<EditTaskState>(
      editTaskNotifierProvider(widget.taskId),
      (previous, next) {
        if (previous != next) {
          if (next.title.isNotEmpty && 
              (titleController.text.isEmpty || titleController.text != next.title)) {
            titleController.text = next.title;
          }
          if (next.description.isNotEmpty &&
              (descriptionController.text.isEmpty || 
               descriptionController.text != next.description)) {
            descriptionController.text = next.description;
          }
        }
      },
    );

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: titleController,
          builder: (context, value, child) {
            return EditTaskBottomPart(
              canSave: value.text.isNotEmpty,
              onSavePressed: () =>
                  _saveTask(notifier: notifier, context: context),
              selectedDate: state.selectedDate ?? DateTime.now(),
              isAllDay: state.isAllDay,
              startTime: state.startTime,
              endTime: state.endTime,
              onDateSelected: (selectedDate, isAllDay, startTime, endTime) {
                notifier.onSelectDate(
                  selectedDate: selectedDate,
                  isAllDay: isAllDay,
                  startTime: startTime,
                  endTime: endTime,
                );
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          EditTaskAppBar(taskId: widget.taskId),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(32),
                    TextField(
                      controller: titleController,
                      focusNode: titleFocusNode,
                      maxLines: null,
                      maxLength: 155,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)?.writeANewTask ?? '',
                        border: InputBorder.none,
                        filled: false,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintStyle: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF121212).withValues(alpha: 0.4),
                            ),
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: titleController,
                      builder: (context, value, child) {
                        final shouldShow = value.text.isNotEmpty;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: shouldShow
                              ? Column(
                                  key: const ValueKey('desc_fields_shown'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Gap(32),
                                    TextField(
                                      controller: descriptionController,
                                      focusNode: descriptionFocusNode,
                                      maxLines: null,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 20,
                                            color: Color(
                                              0xFF121212,
                                            ).withValues(alpha: 0.8),
                                          ),
                                      decoration: InputDecoration(
                                        hintText:
                                            AppLocalizations.of(
                                              context,
                                            )?.description ??
                                            '',
                                        border: InputBorder.none,
                                        filled: false,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: 20,
                                              color: Color(
                                                0xFF121212,
                                              ).withValues(alpha: 0.4),
                                            ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('desc_fields_hidden'),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
