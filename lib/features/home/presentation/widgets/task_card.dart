import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              padding: const EdgeInsets.only(left: 16, right: 0),
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
                            Text(
                              widget.task.task.title,
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        if (widget.task.task.description != null &&
                            widget.task.task.description!.isNotEmpty) ...[
                          const Gap(8),
                          Text(
                            widget.task.task.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColorExtensions.getTextSecondaryColor(
                                context,
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
