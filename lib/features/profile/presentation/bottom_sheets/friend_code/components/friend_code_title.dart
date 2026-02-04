import 'package:flutter/material.dart';
import 'package:taskify/l10n/app_localizations.dart';

class FriendCodeTitle extends StatelessWidget {
  const FriendCodeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      AppLocalizations.of(context)?.friendCode ?? '',
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
