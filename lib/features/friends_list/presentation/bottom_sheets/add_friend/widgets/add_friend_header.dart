import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:design/design.dart';
import 'package:gap/gap.dart';

class AddFriendHeader extends StatelessWidget {
  const AddFriendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Text(
        AppLocalizations.of(context)?.addFriend ?? '',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const Gap(8),
      Text(
        AppLocalizations.of(context)?.addFriendDescription ?? '',
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColorExtensions.getTextSecondaryColor(context),
        ),
      ),
    ],);
  }
}