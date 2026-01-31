import 'package:animated_line_through/animated_line_through.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:design/design.dart';
import 'package:taskify/features/home/presentation/widgets/sub_task_counter.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTaskClicked,
    required this.onCheckboxPressed,
  });

  final TaskWrapperEntity task;
  final VoidCallback onTaskClicked;
  final VoidCallback onCheckboxPressed;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Color _getTextColor(BuildContext context) {
    return widget.task.task.isCompleted
        ? AppColorExtensions.getTextPrimaryColor(context).withValues(alpha: 0.4)
        : AppColorExtensions.getTextPrimaryColor(context);
  }

  Color _getSecondaryTextColor(BuildContext context) {
    return widget.task.task.isCompleted
        ? AppColorExtensions.getTextSecondaryColor(
            context,
          ).withValues(alpha: 0.4)
        : AppColorExtensions.getTextSecondaryColor(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShadow(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTaskClicked,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.task.subTasks.isNotEmpty) ...[
                              SubTaskCounter(subTasks: widget.task.subTasks),
                              const Gap(8),
                            ],
                            Expanded(
                              child: AnimatedLineThrough(
                                duration: const Duration(milliseconds: 260),
                                isCrossed: widget.task.task.isCompleted,
                                color: _getTextColor(context),
                                child: AutoSizeText(
                                  widget.task.task.title,
                                  maxLines: 2,
                                  minFontSize: 14,
                                  semanticsLabel: widget.task.task.title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: _getTextColor(context),
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.task.task.description != null &&
                            widget.task.task.description!.isNotEmpty) ...[
                          const Gap(8),
                          AnimatedLineThrough(
                            duration: const Duration(milliseconds: 260),
                            isCrossed: widget.task.task.isCompleted,
                            color: _getSecondaryTextColor(context),
                            child: Text(
                              widget.task.task.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _getSecondaryTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TaskCheckbox(
                      isChecked: widget.task.task.isCompleted,
                      onPressed: widget.onCheckboxPressed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
