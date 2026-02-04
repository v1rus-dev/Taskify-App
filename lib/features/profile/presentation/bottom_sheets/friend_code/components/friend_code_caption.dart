import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';

class FriendCodeCaption extends StatelessWidget {
  const FriendCodeCaption({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      AppLocalizations.of(context)?.scanOrCopyToAddFriend ?? '',
      style: theme.textTheme.bodySmall?.copyWith(
        fontSize: 12,
        color: AppColorExtensions.getTextSecondaryColor(context),
      ),
      textAlign: TextAlign.center,
    );
  }
}
