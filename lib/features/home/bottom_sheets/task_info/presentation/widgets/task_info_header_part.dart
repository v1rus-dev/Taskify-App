import 'package:design/design.dart';
import 'package:design/themes/themes.dart';
import 'package:design/widgets/task_checkbox.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:flutter/material.dart';

class TaskInfoHeaderPart extends StatelessWidget {
  const TaskInfoHeaderPart({
    super.key,
    required this.task,
    required this.onCheckBoxPressed,
  });

  final TaskWrapperEntity task;
  final VoidCallback onCheckBoxPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppInsets.sheetVertical,
              left: AppInsets.sheetHorizontalSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time:', style: theme.textTheme.labelSmall),
                const Gap(4),
                Text(
                  task.task.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColorExtensions.getTextPrimaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: TaskCheckbox(
            isChecked: task.task.isCompleted,
            onPressed: onCheckBoxPressed,
          ),
        ),
      ],
    );
  }
}
