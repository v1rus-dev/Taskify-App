import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/domain/models/time_format_type.dart';

class SelectTimeFormatBottomSheet extends StatelessWidget {
  const SelectTimeFormatBottomSheet({super.key, required this.selectedType});

  final TimeFormatType selectedType;

  void _onTimeFormatPressed(BuildContext context, TimeFormatType type) {
    Navigator.of(context).pop(type == selectedType ? null : type);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String descriptionFor(TimeFormatType type) {
      return selectedType == type ? 'Selected' : '';
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
          Text('Time format', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppInsets.sheetTitleBottom),
          CardWithActions(
            actions: [
              CardAction(
                title: TimeFormatType.hour24.label,
                description: descriptionFor(TimeFormatType.hour24),
                descriptionColor:
                    descriptionColorFor(context, TimeFormatType.hour24),
                onPressed: () => _onTimeFormatPressed(context, TimeFormatType.hour24),
              ),
              CardAction(
                title: TimeFormatType.hour12.label,
                description: descriptionFor(TimeFormatType.hour12),
                descriptionColor:
                    descriptionColorFor(context, TimeFormatType.hour12),
                onPressed: () => _onTimeFormatPressed(context, TimeFormatType.hour12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
