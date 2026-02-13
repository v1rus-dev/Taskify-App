import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/data/models/task_recurrence.dart';
import 'package:taskify/l10n/app_localizations.dart';

class RecurrenceTypeBottomSheet extends StatelessWidget {
  const RecurrenceTypeBottomSheet({
    super.key,
    required this.selectedRecurrence,
    required this.onSelected,
  });

  final TaskRecurrence? selectedRecurrence;
  final ValueChanged<TaskRecurrence?> onSelected;

  String _optionLabel(BuildContext context, TaskRecurrence? recurrence) {
    final l10n = AppLocalizations.of(context);
    if (recurrence == null) {
      return l10n?.doesNotRepeat ?? '';
    }
    return switch (recurrence.frequency) {
      TaskRecurrenceFrequency.daily => l10n?.recurrenceDaily ?? '',
      TaskRecurrenceFrequency.weekly => l10n?.recurrenceWeekly ?? '',
      TaskRecurrenceFrequency.monthly => l10n?.recurrenceMonthly ?? '',
      TaskRecurrenceFrequency.yearly => l10n?.recurrenceYearly ?? '',
    };
  }

  String _descriptionFor(BuildContext context, TaskRecurrence? recurrence) {
    return selectedRecurrence == recurrence
        ? AppLocalizations.of(context)?.selected ?? ''
        : '';
  }

  Color? _descriptionColorFor(
    BuildContext context,
    TaskRecurrence? recurrence,
  ) {
    return recurrence == selectedRecurrence
        ? AppColorExtensions.getPrimaryAccentColor(context)
        : null;
  }

  void _selectAndClose(BuildContext context, TaskRecurrence? recurrence) {
    onSelected(recurrence);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final options = <TaskRecurrence?>[
      null,
      const TaskRecurrence(frequency: TaskRecurrenceFrequency.daily),
      const TaskRecurrence(frequency: TaskRecurrenceFrequency.weekly),
      const TaskRecurrence(frequency: TaskRecurrenceFrequency.monthly),
      const TaskRecurrence(frequency: TaskRecurrenceFrequency.yearly),
    ];

    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Text(
            l10n?.recurrence ?? '',
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
