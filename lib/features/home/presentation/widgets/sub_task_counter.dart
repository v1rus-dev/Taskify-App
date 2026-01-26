import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/domain/tags/models/sub_task.dart';

class SubTaskCounter extends StatelessWidget {
  const SubTaskCounter({super.key, required this.subTasks});

  final List<SubTaskEntity> subTasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorExtensions.getPrimaryAccentColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${subTasks.where((element) => element.isCompleted).length}/${subTasks.length}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColorExtensions.getPrimaryAccentColor(context).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
