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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Period', style: theme.textTheme.displayMedium),
          const SizedBox(height: 24),
          CardWithActions(
            actions: [
              CardAction(
                title: 'All day',
                description: _descriptionFor(TaskDurationType.allDay),
                onPressed: () {
                  onSelected(TaskDurationType.allDay);
                  Navigator.of(context).pop();
                },
              ),
              CardAction(
                title: 'Period',
                description: _descriptionFor(TaskDurationType.period),
                onPressed: () {
                  onSelected(TaskDurationType.period);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }
}
