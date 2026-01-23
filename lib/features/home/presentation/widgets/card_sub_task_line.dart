import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';

class CardSubTaskLine extends StatelessWidget {
  const CardSubTaskLine({
    super.key,
    required this.subTask,
    required this.onCheckboxPressed,
  });
  final SubTaskEntity subTask;
  final Function(SubTaskEntity) onCheckboxPressed;

  void _onCheckboxPressed() {
    onCheckboxPressed(subTask);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SubTaskCheckbox(
            isChecked: subTask.isCompleted,
            onPressed: _onCheckboxPressed,
          ),
          const Gap(16),
          Expanded(
            child: Text(subTask.title, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
