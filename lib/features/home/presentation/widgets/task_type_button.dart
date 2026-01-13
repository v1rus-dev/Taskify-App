import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/domain/models/tasks_view_type.dart';

class TaskTypeButton extends StatelessWidget {
  const TaskTypeButton({
    super.key,
    required this.tasksViewType,
    required this.isSelected,
    required this.onPressed,
  });

  final TasksViewType tasksViewType;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppShadow(
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7990F8).withValues(alpha: 0.6)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeInOut,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF121212).withValues(alpha: 0.5),
                ),
                child: Text(tasksViewType.getTitle(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
