import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AddTagButton extends StatelessWidget {
  const AddTagButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColorExtensions.getButtonDisabledBackgroundColor(context),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            l10n?.addTag ?? '',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColorExtensions.getButtonDisabledTextColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
