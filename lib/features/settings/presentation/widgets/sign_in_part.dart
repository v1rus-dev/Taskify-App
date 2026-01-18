import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/settings/presentation/widgets/google_sign_in_button.dart';
import 'package:taskify/features/settings/presentation/widgets/apple_sign_in_button.dart';
import 'package:taskify/core/auth/auth_notifier.dart';

class SignInPart extends StatelessWidget {
  const SignInPart({super.key});

  void _signInWithGoogle(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _signInWithApple(BuildContext context) {
    context.read<AuthCubit>().signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.select((AuthCubit c) => c.state.session);

    if (session != null) {
      return const SizedBox.shrink();
    }

    if (Platform.isAndroid) {
      return GoogleSignInButton(
        onPressed: () => _signInWithGoogle(context),
      );
    }

    return Column(
      children: [
        const Gap(24),
        Row(
          children: [
            Expanded(
              child: GoogleSignInButton(
                onPressed: () => _signInWithGoogle(context),
              ),
            ),
            const Gap(16),
            Expanded(
              child: AppleSignInButton(
                onPressed: () => _signInWithApple(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}