import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/domain/models/time_format_type.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectTimeFormatBottomSheet extends StatelessWidget {
  const SelectTimeFormatBottomSheet({super.key, required this.selectedType});

  final TimeFormatType selectedType;

  void _onTimeFormatPressed(BuildContext context, TimeFormatType type) {
    Navigator.of(context).pop(type == selectedType ? null : type);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    String descriptionFor(TimeFormatType type) {
      return selectedType == type ? (l10n?.selected ?? '') : '';
    }

    Color? descriptionColorFor(BuildContext context, TimeFormatType type) {
      return type == selectedType
          ? AppColorExtensions.getPrimaryAccentColor(context)
          : null;
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppInsets.sheetHorizontal, vertical: AppInsets.sheetVertical),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n?.timeFormat ?? '',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppInsets.sheetTitleBottom),
          CardWithActions(
            actions: [
              CardActionEntry(
                CardAction(
                  title: l10n?.timeFormat24 ?? '',
                  description: descriptionFor(TimeFormatType.hour24),
                  descriptionColor:
                      descriptionColorFor(context, TimeFormatType.hour24),
                  onPressed: () =>
                      _onTimeFormatPressed(context, TimeFormatType.hour24),
                ),
              ),
              CardActionEntry(
                CardAction(
                  title: l10n?.timeFormat12 ?? '',
                  description: descriptionFor(TimeFormatType.hour12),
                  descriptionColor:
                      descriptionColorFor(context, TimeFormatType.hour12),
                  onPressed: () =>
                      _onTimeFormatPressed(context, TimeFormatType.hour12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
