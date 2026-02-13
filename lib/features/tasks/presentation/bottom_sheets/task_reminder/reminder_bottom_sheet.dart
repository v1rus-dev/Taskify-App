import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/data/models/task_reminder.dart';
import 'package:taskify/l10n/app_localizations.dart';

class ReminderBottomSheet extends StatelessWidget {
  const ReminderBottomSheet({
    super.key,
    required this.selectedReminder,
    required this.onSelected,
  });

  final TaskReminder? selectedReminder;
  final ValueChanged<TaskReminder?> onSelected;

  String _optionLabel(BuildContext context, TaskReminder? reminder) {
    final l10n = AppLocalizations.of(context);
    if (reminder == null) {
      return l10n?.noReminder ?? '';
    }

    return switch (reminder.type) {
      TaskReminderType.atTime => l10n?.reminderAtTime ?? '',
      TaskReminderType.fiveMinutesBefore =>
        l10n?.reminderFiveMinutesBefore ?? '',
      TaskReminderType.tenMinutesBefore => l10n?.reminderTenMinutesBefore ?? '',
      TaskReminderType.fifteenMinutesBefore =>
        l10n?.reminderFifteenMinutesBefore ?? '',
      TaskReminderType.thirtyMinutesBefore =>
        l10n?.reminderThirtyMinutesBefore ?? '',
      TaskReminderType.oneHourBefore => l10n?.reminderOneHourBefore ?? '',
      TaskReminderType.oneDayBefore => l10n?.reminderOneDayBefore ?? '',
    };
  }

  String _descriptionFor(BuildContext context, TaskReminder? reminder) {
    return selectedReminder == reminder
        ? AppLocalizations.of(context)?.selected ?? ''
        : '';
  }

  Color? _descriptionColorFor(BuildContext context, TaskReminder? reminder) {
    return reminder == selectedReminder
        ? AppColorExtensions.getPrimaryAccentColor(context)
        : null;
  }

  void _selectAndClose(BuildContext context, TaskReminder? reminder) {
    onSelected(reminder);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final options = <TaskReminder?>[
      null,
      const TaskReminder(type: TaskReminderType.atTime),
      const TaskReminder(type: TaskReminderType.fiveMinutesBefore),
      const TaskReminder(type: TaskReminderType.tenMinutesBefore),
      const TaskReminder(type: TaskReminderType.fifteenMinutesBefore),
      const TaskReminder(type: TaskReminderType.thirtyMinutesBefore),
      const TaskReminder(type: TaskReminderType.oneHourBefore),
      const TaskReminder(type: TaskReminderType.oneDayBefore),
    ];

    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Text(
            l10n?.reminder ?? '',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          CardWithActions(
            actions: options
                .map(
                  (option) => CardActionEntry(
                    CardAction(
                      title: _optionLabel(context, option),
                      description: _descriptionFor(context, option),
                      descriptionColor: _descriptionColorFor(context, option),
                      onPressed: () => _selectAndClose(context, option),
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(AppInsets.sheetBottomSmall),
        ],
      ),
    );
  }
}
