import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/settings/presentation/widgets/google_sign_in_button.dart';
import 'package:taskify/features/settings/presentation/widgets/apple_sign_in_button.dart';
import 'package:taskify/core/auth/auth_notifier.dart';

class SignInPart extends ConsumerWidget {
  const SignInPart({super.key});

  void _signInWithGoogle(AuthNotifier authNotifier) {
    authNotifier.signInWithGoogle();
  }

  void _signInWithApple(AuthNotifier authNotifier) {
    authNotifier.signInWithApple();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);

    if (authState.session != null) {
      return SizedBox.shrink();
    }

    if (Platform.isAndroid) {
      return GoogleSignInButton(
        onPressed: () => _signInWithGoogle(authNotifier),
      );
    }

    return Column(
      children: [
        const Gap(24),
        Row(
          children: [
            Expanded(
              child: GoogleSignInButton(
                onPressed: () => _signInWithGoogle(authNotifier),
              ),
            ),
            const Gap(16),
            Expanded(
              child: AppleSignInButton(
                onPressed: () => _signInWithApple(authNotifier),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
