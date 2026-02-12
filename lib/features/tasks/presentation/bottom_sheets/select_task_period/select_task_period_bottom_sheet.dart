import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/data/models/task_duration_type.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectTaskPeriodBottomSheet extends StatelessWidget {
  const SelectTaskPeriodBottomSheet({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  final TaskDurationType selectedType;
  final ValueChanged<TaskDurationType> onSelected;

  String _descriptionFor(BuildContext context, TaskDurationType type) {
    return selectedType == type
        ? AppLocalizations.of(context)?.selected ?? ''
        : '';
  }

  Color? _descriptionColorFor(BuildContext context, TaskDurationType type) {
    return type == selectedType ? AppColorExtensions.getPrimaryAccentColor(context) : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Text(
            l10n?.period ?? '',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          CardWithActions(
            actions: [
              CardActionEntry(
                CardAction(
                  title: l10n?.allDay ?? '',
                  description:
                      _descriptionFor(context, TaskDurationType.allDay),
                  descriptionColor:
                      _descriptionColorFor(context, TaskDurationType.allDay),
                  onPressed: () {
                    onSelected(TaskDurationType.allDay);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              CardActionEntry(
                CardAction(
                  title: l10n?.period ?? '',
                  description:
                      _descriptionFor(context, TaskDurationType.period),
                  descriptionColor:
                      _descriptionColorFor(context, TaskDurationType.period),
                  onPressed: () {
                    onSelected(TaskDurationType.period);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const Gap(AppInsets.sheetBottomSmall),
        ],
      ),
    );
  }
}
