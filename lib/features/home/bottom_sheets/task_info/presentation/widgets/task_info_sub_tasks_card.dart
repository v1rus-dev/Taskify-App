import 'package:animated_line_through/animated_line_through.dart';
import 'package:design/themes/color/app_color_extensions.dart';
import 'package:design/widgets/app_shadow.dart';
import 'package:design/widgets/task_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';

class TaskInfoSubTasksCard extends StatelessWidget {
  const TaskInfoSubTasksCard({
    super.key,
    required this.subTasks,
    required this.onCheckboxPressed,
  });

  final List<SubTaskEntity> subTasks;
  final Function(SubTaskEntity) onCheckboxPressed;

  void _onCheckboxPressed(SubTaskEntity subTask) {
    onCheckboxPressed(subTask);
  }

  BorderRadius _borderRadiusForPosition(_SubTaskPositionType positionType) {
    switch (positionType) {
      case _SubTaskPositionType.top:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case _SubTaskPositionType.bottom:
        return const BorderRadius.vertical(bottom: Radius.circular(16));
      case _SubTaskPositionType.middle:
        return BorderRadius.zero;
      case _SubTaskPositionType.single:
        return BorderRadius.circular(16);
    }
  }

  Widget _buildSubTaskItem(
    BuildContext context,
    SubTaskEntity subTask,
    _SubTaskPositionType positionType,
  ) {
    final theme = Theme.of(context);
    final radius = _borderRadiusForPosition(positionType);
    final textColor = subTask.isCompleted
        ? AppColorExtensions.getTextPrimaryColor(context).withValues(alpha: 0.4)
        : AppColorExtensions.getTextPrimaryColor(context);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: () => _onCheckboxPressed(subTask),
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TaskCheckbox(
                  isChecked: subTask.isCompleted,
                  onPressed: () => _onCheckboxPressed(subTask),
                ),
              ),
              const Gap(4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AnimatedLineThrough(
                    isCrossed: subTask.isCompleted,
                    color: textColor,
                    strokeWidth: 1,
                    duration: const Duration(milliseconds: 260),
                    child: Text(
                      subTask.title,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (subTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    for (var i = 0; i < subTasks.length; i++) {
      final positionType = i == 0
          ? subTasks.length == 1
                ? _SubTaskPositionType.single
                : _SubTaskPositionType.top
          : i == subTasks.length - 1
          ? _SubTaskPositionType.bottom
          : _SubTaskPositionType.middle;

      children.add(_buildSubTaskItem(context, subTasks[i], positionType));

      if (i != subTasks.length - 1) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: AppColorExtensions.getDividerColor(context),
          ),
        );
      }
    }

    return AppShadow(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColorExtensions.getCardColor(context),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

enum _SubTaskPositionType { top, middle, bottom, single }

