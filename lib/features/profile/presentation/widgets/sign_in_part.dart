import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/sign_in/sign_in_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SignInPart extends StatelessWidget {
  const SignInPart({super.key});

  _showSignInBottomSheet(BuildContext context) {
    showAppBottomSheet(
      context: context,
      type: AppBottomSheetType.floating,
      child: SignInBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = context.select((AuthCubit c) => c.state.session);

    if (session != null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            AppLocalizations.of(context)?.signInToGetMoreFromTaskify ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Gap(4),
        Flexible(
          child: Text(
            AppLocalizations.of(
                  context,
                )?.signInToGetMoreFromTaskifyDescription ??
                '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFFA6A6A6),
            ),
          ),
        ),
        const Gap(20),
        CardWithActions(
          actions: [
            CardActionEntry(
              CardAction(
                title: AppLocalizations.of(context)?.signInToYourAccount ?? '',
                onPressed: () => _showSignInBottomSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
