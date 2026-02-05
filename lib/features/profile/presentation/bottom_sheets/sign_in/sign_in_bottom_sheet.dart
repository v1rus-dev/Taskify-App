import 'dart:io';

import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/core/auth/auth_cubit.dart';

class SignInBottomSheet extends StatelessWidget {
  const SignInBottomSheet({super.key});

  void _onSignInWithGooglePressed(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
    context.pop();
  }

  void _onSignInWithApplePressed(BuildContext context) {
    context.read<AuthCubit>().signInWithApple();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingBottomSheetLayout(
      children: [
        Text(
          AppLocalizations.of(context)?.signIn ?? '',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppLocalizations.of(context)?.signInDescription ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFFA6A6A6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Gap(16),
        CardWithActions(
          actions: [
            CardCustomEntry(
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.google,
                    package: AppIcons.packageName,
                    width: 24,
                    height: 24,
                  ),
                  const Gap(8),
                  Text(
                    AppLocalizations.of(context)?.signInWithGoogle ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () => _onSignInWithGooglePressed(context),
            ),
            if (Platform.isIOS)
              CardCustomEntry(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.apple,
                      package: AppIcons.packageName,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      AppLocalizations.of(context)?.signInWithApple ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _onSignInWithApplePressed(context),
              ),
          ],
        ),
      ],
    );
  }
}
