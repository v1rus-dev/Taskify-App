import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/widgets/screen_app_bar.dart';
import 'package:taskify/domain/entities/time_format_type.dart';
import 'package:taskify/features/settings/presentation/select_time_format_bottom_sheet.dart';
import 'package:taskify/features/settings/presentation/widgets/account_part.dart';
import 'package:taskify/features/settings/presentation/widgets/sign_in_part.dart';
import 'package:taskify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => SettingsBloc(
      appConfigurationInteractor: locator<AppConfigurationInteractor>(),
    )..add(const SettingsEvent.started()),
    child: const SettingsScreen(),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openTimeFormatSheet(
    BuildContext context,
    TimeFormatType selectedType,
  ) async {
    final result = await showAppModalBottomSheet<TimeFormatType>(
      context: context,
      useSafeArea: true,
      child: SelectTimeFormatBottomSheet(selectedType: selectedType),
    );
    if (context.mounted) {
      if (result != null) {
        context.read<SettingsBloc>().add(
          SettingsEvent.timeFormatChanged(result),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ScreenAppBar(title: 'Settings'),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Column(
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
                            description: state.timeFormat.label,
                            onPressed: () =>
                                _openTimeFormatSheet(context, state.timeFormat),
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
          );
        },
      ),
    );
  }
}
