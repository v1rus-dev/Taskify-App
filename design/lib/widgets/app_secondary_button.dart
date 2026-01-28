import 'package:flutter/material.dart';
import 'package:design/themes/themes.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColorExtensions.getPrimaryAccentColor(
      context,
    ).withValues(alpha: 0.6);

    return Material(
      borderRadius: BorderRadius.circular(24),
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
