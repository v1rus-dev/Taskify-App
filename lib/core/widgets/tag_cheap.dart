import 'package:flutter/material.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';

class TagCheap extends StatelessWidget {
  const TagCheap({super.key, required this.tag, required this.onPressed});

  final TagEntity tag;
  final VoidCallback onPressed;

  Color _getBackgroundColor(BuildContext context) {
    return tag.color.withValues(alpha: 0.1);
  }

  Color _getTextColor(BuildContext context) {
    return tag.color;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: _getBackgroundColor(context),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tag.title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

