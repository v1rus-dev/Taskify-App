import 'package:flutter/material.dart';
import 'package:design/design.dart';

class AppEditText extends StatelessWidget {
  const AppEditText({
    super.key,
    required this.hint,
    required this.controller,
    this.trailing,
  });

  final String hint;
  final TextEditingController controller;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColorExtensions.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColorExtensions.getTextPrimaryColor(context),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
