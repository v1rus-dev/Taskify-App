import 'package:design/design.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

class TaskInfoDescriptionPart extends StatelessWidget {
  const TaskInfoDescriptionPart({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppInsets.sheetHorizontalSmall),
      child: Column(
        children: [
          const Gap(12),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColorExtensions.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
