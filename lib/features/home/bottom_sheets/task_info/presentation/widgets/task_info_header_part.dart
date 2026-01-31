import 'package:design/design.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/domain/tasks/ext/task_entity_ext.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';

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
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: l10n?.timeLabel ?? '',
                        style: theme.textTheme.labelSmall,
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: task.task.duration(
                          use24Hour: use24Hour,
                          allDayLabel: l10n?.allDay ?? '',
                        ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
