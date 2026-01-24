import 'package:design/constants/app_icons.dart';
import 'package:design/constants/animation_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:design/design.dart';
import 'package:taskify/features/home/presentation/widgets/card_sub_task_line.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _onSubtaskCheckboxPressed(SubTaskEntity subTask) {
    context.read<HomeBloc>().add(HomeEvent.toogleSubTask(subTask));
  }

  Widget _buildCheckbox() {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: AnimationDurations.defaultDuration,
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: widget.onCheckboxPressed,
          customBorder: const CircleBorder(),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
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
                          Color(0xFF27C255).withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
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
        ),
      ),
    );
  }

  Widget _buildSubtasks() {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Gap(12),
        Divider(color: theme.dividerColor, height: 1,),
        ...widget.task.subTasks.indexed.map(
          (e) => Column(
            children: [
              CardSubTaskLine(
                subTask: e.$2,
                onCheckboxPressed: _onSubtaskCheckboxPressed,
              ),
              if (e.$1 < widget.task.subTasks.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: theme.dividerColor, height: 1,),
                ),
            ],
          ),
        ),
      ],
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
            padding: EdgeInsets.only(
              top: 8,
              bottom: widget.task.subTasks.isNotEmpty ? 4 : 8,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0),
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
                if (widget.task.subTasks.isNotEmpty) _buildSubtasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
