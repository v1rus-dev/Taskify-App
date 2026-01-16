import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/features/settings/providers/settings_notifier.dart';

class SelectTimeFormatBottomSheet extends ConsumerWidget {
  const SelectTimeFormatBottomSheet({super.key});

  void _onTimeFormatPressed(BuildContext context, SettingsNotifier notifier, TimeFormatType type) async {
    await notifier.setTimeFormat(type);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    String descriptionFor(TimeFormatType type) {
      return state.timeFormat == type ? 'Selected' : '';
    }

    Color? descriptionColorFor(BuildContext context, TimeFormatType type) {
      return type == state.timeFormat
          ? AppColorExtensions.getPrimaryAccentColor(context)
          : null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Text('Time format', style: theme.textTheme.displayMedium),
          const SizedBox(height: 24),
          CardWithActions(
            actions: [
              CardAction(
                title: TimeFormatType.hour24.label,
                description: descriptionFor(TimeFormatType.hour24),
                descriptionColor:
                    descriptionColorFor(context, TimeFormatType.hour24),
                onPressed: () => _onTimeFormatPressed(context, notifier, TimeFormatType.hour24),
              ),
              CardAction(
                title: TimeFormatType.hour12.label,
                description: descriptionFor(TimeFormatType.hour12),
                descriptionColor:
                    descriptionColorFor(context, TimeFormatType.hour12),
                onPressed: () async {
                  await notifier.setTimeFormat(TimeFormatType.hour12);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Gap(40),
        ],
      ),
    );
  }
}
