import 'package:flutter/material.dart';
import 'package:taskify/domain/tags/models/tag.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onPressed,
  });

  final TagEntity tag;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        isSelected ? tag.color.withValues(alpha: 0.1) : Colors.transparent;
    final borderColor = tag.color.withValues(alpha: 0.35);
    final border = isSelected ? Border.all(color: Colors.transparent) : Border.all(color: borderColor);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: border,
          ),
          child: Text(
            tag.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: tag.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}