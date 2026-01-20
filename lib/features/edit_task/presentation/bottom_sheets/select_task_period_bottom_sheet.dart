import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';

class SelectTaskPeriodBottomSheet extends StatelessWidget {
  const SelectTaskPeriodBottomSheet({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  final TaskDurationType selectedType;
  final ValueChanged<TaskDurationType> onSelected;

  String _descriptionFor(TaskDurationType type) {
    return selectedType == type ? 'Selected' : '';
  }

  Color? _descriptionColorFor(BuildContext context, TaskDurationType type) {
    return type == selectedType ? AppColorExtensions.getPrimaryAccentColor(context) : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Text('Period', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          CardWithActions(
            actions: [
              CardAction(
                title: 'All day',
                description: _descriptionFor(TaskDurationType.allDay),
                descriptionColor: _descriptionColorFor(context, TaskDurationType.allDay),
                onPressed: () {
                  onSelected(TaskDurationType.allDay);
                  Navigator.of(context).pop();
                },
              ),
              CardAction(
                title: 'Period',
                description: _descriptionFor(TaskDurationType.period),
                descriptionColor: _descriptionColorFor(context, TaskDurationType.period),
                onPressed: () {
                  onSelected(TaskDurationType.period);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Gap(AppInsets.sheetBottomSmall),
        ],
      ),
    );
  }
}
