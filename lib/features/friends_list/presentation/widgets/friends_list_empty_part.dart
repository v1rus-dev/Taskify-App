import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:design/design.dart';

class FriendsListEmptyPart extends StatelessWidget {
  const FriendsListEmptyPart({super.key, required this.onAddFriendPressed});

  final VoidCallback onAddFriendPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.noFriendsTitle ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(4),
            Text(
              AppLocalizations.of(context)?.noFriendsDescription ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColorExtensions.getTextSecondaryColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            AppTextButton(
              text: AppLocalizations.of(context)?.addFriends ?? '',
              onPressed: onAddFriendPressed,
            ),
          ],
        ),
      ),
    );
  }
}
