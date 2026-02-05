import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectThemeBottomSheet extends StatelessWidget {
  const SelectThemeBottomSheet({
    super.key,
    required this.selectedMode,
  });

  final AppThemeMode selectedMode;

  void _onThemePressed(BuildContext context, AppThemeMode mode) {
    Navigator.of(context).pop(mode == selectedMode ? null : mode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    String descriptionFor(AppThemeMode mode) {
      return selectedMode == mode ? (l10n?.selected ?? '') : '';
    }

    Color? descriptionColorFor(BuildContext context, AppThemeMode mode) {
      return mode == selectedMode
          ? AppColorExtensions.getPrimaryAccentColor(context)
          : null;
    }

    return FloatingBottomSheetLayout(
      children: [
        Text(
          l10n?.theme ?? '',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppInsets.sheetTitleBottom),
        CardWithActions(
          actions: [
            CardActionEntry(
              CardAction(
                title: l10n?.themeLight ?? '',
                description: descriptionFor(AppThemeMode.light),
                descriptionColor:
                    descriptionColorFor(context, AppThemeMode.light),
                onPressed: () => _onThemePressed(context, AppThemeMode.light),
              ),
            ),
            CardActionEntry(
              CardAction(
                title: l10n?.themeDark ?? '',
                description: descriptionFor(AppThemeMode.dark),
                descriptionColor:
                    descriptionColorFor(context, AppThemeMode.dark),
                onPressed: () => _onThemePressed(context, AppThemeMode.dark),
              ),
            ),
            CardActionEntry(
              CardAction(
                title: l10n?.themeSystem ?? '',
                description: descriptionFor(AppThemeMode.system),
                descriptionColor:
                    descriptionColorFor(context, AppThemeMode.system),
                onPressed: () => _onThemePressed(context, AppThemeMode.system),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
