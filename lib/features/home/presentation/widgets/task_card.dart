import 'package:design/constants/app_icons.dart';
import 'package:design/constants/animation_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskify/domain/entities/task_with_sub_tasks.dart';
import 'package:design/design.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task, required this.onTaskClicked, required this.onCheckboxPressed});

  final TaskWithSubTasksEntity task;
  final VoidCallback onTaskClicked;
  final VoidCallback onCheckboxPressed;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Widget _buildCheckbox() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: AnimationDurations.defaultDuration),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: widget.onCheckboxPressed,
          customBorder: const CircleBorder(),
          borderRadius: BorderRadius.circular(24),
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 100),
            child: widget.task.task.isCompleted
                ? SvgPicture.asset(
                    AppIcons.fillChecked,
                    key: const ValueKey('checked'),
                    package: AppIcons.packageName,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        Color(0xFF27C255).withValues(alpha: 0.6), BlendMode.srcIn),
                  )
                : SvgPicture.asset(
                    AppIcons.circle,
                    key: const ValueKey('circle'),
                    package: AppIcons.packageName,
                    width: 24,
                    height: 24,
                  ),
          ),
        ),
      ),
    );
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.task.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildCheckbox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
