import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/core/widgets/screen_app_bar.dart';
import 'package:taskify/domain/models/time_format_type.dart';
import 'package:taskify/features/profile/presentation/select_time_format_bottom_sheet.dart';
import 'package:taskify/features/profile/presentation/widgets/account_part.dart';
import 'package:taskify/features/profile/presentation/widgets/sign_in_part.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => ProfileBloc(
      appConfigurationInteractor: locator<AppConfigurationInteractor>(),
    )..add(const ProfileEvent.started()),
    child: const ProfileScreen(),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openTimeFormatSheet(
    BuildContext context,
    TimeFormatType selectedType,
  ) async {
    final result = await showAppBottomSheet<TimeFormatType>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectTimeFormatBottomSheet(selectedType: selectedType),
    );
    if (context.mounted) {
      if (result != null) {
        context.read<ProfileBloc>().add(
          ProfileEvent.onTimeFormatChanged(result),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSideEffectListener<ProfileBloc, ProfileSideEffect>(
      bloc: context.read<ProfileBloc>(),
      listener: (context, effect) {
        effect.when(
          showLoadingDialog: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return PopScope(
                  canPop: false,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          dismissLoadingDialog: () {
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const ScreenAppBar(title: 'Profile'),
        body: BlocBuilder<ProfileBloc, ProfileState>(
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
                              onPressed: () => _openTimeFormatSheet(
                                context,
                                state.timeFormat,
                              ),
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
      ),
    );
  }
}
