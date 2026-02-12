import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/features/profile/presentation/widgets/account_part.dart';
import 'package:taskify/features/profile/presentation/widgets/app_configuration_part.dart';
import 'package:taskify/features/profile/presentation/widgets/debug_part.dart';
import 'package:taskify/features/profile/presentation/widgets/profile_part.dart';
import 'package:taskify/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocSideEffectListener<ProfileBloc, ProfileSideEffect>(
      listener: (effect) {
        if (effect is ProfileShowLoadingDialog) {
          showAppLoadingDialog(context: context);
        }
        if (effect is ProfileDismissLoadingDialog) {
          dismissAppLoadingDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ScreenAppBar(title: l10n?.profile ?? ''),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const ProfilePart(),
                    const Gap(12),
                    const AppConfigurationPart(),
                    const DebugPart(),
                    const Gap(12),
                    AccountPart(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
