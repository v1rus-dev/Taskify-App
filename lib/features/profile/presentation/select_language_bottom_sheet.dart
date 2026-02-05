import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/profile/presentation/language_selection.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectLanguageBottomSheet extends StatelessWidget {
  const SelectLanguageBottomSheet({
    super.key,
    required this.selectedLocale,
  });

  final Locale? selectedLocale;

  void _onLocalePressed(BuildContext context, Locale? locale) {
    final selection = locale == null
        ? const LanguageSelectionSystem()
        : LanguageSelectionOverride(locale);
    Navigator.of(context).pop(selection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    bool isSelected(Locale? locale) {
      if (locale == null) return selectedLocale == null;
      return selectedLocale?.languageCode == locale.languageCode;
    }

    String descriptionFor(Locale? locale) {
      return isSelected(locale) ? (l10n?.selected ?? '') : '';
    }

    Color? descriptionColorFor(BuildContext context, Locale? locale) {
      return isSelected(locale)
          ? AppColorExtensions.getPrimaryAccentColor(context)
          : null;
    }

    return FloatingBottomSheetLayout(
      children: [
        Text(
          l10n?.language ?? '',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppInsets.sheetTitleBottom),
        CardWithActions(
          actions: [
            CardActionEntry(
              CardAction(
                title: l10n?.localeDisplayName(null) ?? '',
                description: descriptionFor(null),
                descriptionColor: descriptionColorFor(context, null),
                onPressed: () => _onLocalePressed(context, null),
              ),
            ),
            ...AppLocalizations.supportedLocales.map(
              (locale) => CardActionEntry(
                CardAction(
                  title: l10n?.localeDisplayName(locale) ?? '',
                  description: descriptionFor(locale),
                  descriptionColor: descriptionColorFor(context, locale),
                  onPressed: () => _onLocalePressed(context, locale),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
