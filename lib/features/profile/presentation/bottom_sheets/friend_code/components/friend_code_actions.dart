import 'dart:io';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskify/l10n/app_localizations.dart';

class FriendCodeActions extends StatelessWidget {
  const FriendCodeActions({
    super.key,
    required this.friendCode,
    required this.isLoading,
    required this.onGeneratePressed,
  });

  final String friendCode;
  final bool isLoading;
  final VoidCallback onGeneratePressed;

  void _onSharePressed(BuildContext context) {
    if (friendCode.isEmpty) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    Share.share(
      [
        l10n?.shareFriendCodeMessage ?? '',
        friendCode,
      ].where((value) => value.isNotEmpty).join('\n'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isIos = Platform.isIOS;
    return CardWithActions(
      actions: [
        CardActionEntry(
          CardAction(
            title: l10n?.sharedFriendCode ?? '',
            onPressed: isLoading ? null : () => _onSharePressed(context),
            isEnabled: !isLoading,
            showArrow: false,
            icon: SvgPicture.asset(
              isIos ? AppIcons.shareIOS : AppIcons.shareAndroid,
              package: AppIcons.packageName,
              width: 24,
              height: 24,
            ),
          ),
        ),
        CardActionEntry(
          CardAction(
            title: l10n?.generateNewFriendCode ?? '',
            onPressed: isLoading ? null : onGeneratePressed,
            isEnabled: !isLoading,
            showArrow: false,
            icon: SvgPicture.asset(
              AppIcons.redo,
              package: AppIcons.packageName,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
