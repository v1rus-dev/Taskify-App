import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/widgets/screen_app_bar.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/features/settings/presentation/select_time_format_bottom_sheet.dart';
import 'package:taskify/features/settings/presentation/widgets/account_part.dart';
import 'package:taskify/features/settings/presentation/widgets/sign_in_part.dart';
import 'package:taskify/features/settings/providers/settings/settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openTimeFormatSheet(BuildContext context) async {
    showAppModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      child: const SelectTimeFormatBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsState = ref.watch(settingsNotifierProvider);
    final selectedType = settingsState.timeFormat;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ScreenAppBar(title: 'Settings'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SignInPart(),
                  const Gap(24),
                  CardWithActions(
                    actions: [
                      CardAction(
                        title: 'Time format',
                        description: selectedType.label,
                        onPressed: () => _openTimeFormatSheet(context),
                      ),
                    ],
                  ),
                  const Gap(24),
                  AccountPart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
