import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:design/constants/app_icons.dart';
import 'package:gap/gap.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, this.showText = true, required this.onPressed});

  final bool showText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.google,
                package: AppIcons.packageName,
                width: 24,
                height: 24,
              ),
              if (showText) ...[
              const Gap(8),
              Text(
                  'Sign in with Google',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
