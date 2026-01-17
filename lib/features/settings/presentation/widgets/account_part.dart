import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:taskify/core/auth/auth_notifier.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/settings/providers/settings/settings_notifier.dart';

class AccountPart extends ConsumerWidget {
  List<CardAction> _buildActions(BuildContext context, WidgetRef ref, AuthState authState) {
    return [
      CardAction(
        title: 'Exit from account',
        icon: SvgPicture.asset(AppIcons.logout, package: AppIcons.packageName, width: 24, height: 24),
        onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
      ),
      CardAction(
        title: 'Delete account',
        icon: SvgPicture.asset(AppIcons.trash, package: AppIcons.packageName, width: 24, height: 24, colorFilter: ColorFilter.mode(AppColorExtensions.getErrorColor(context), BlendMode.srcIn),),
        titleColor: AppColorExtensions.getErrorColor(context),
        onPressed: () =>
            ref.read(settingsNotifierProvider.notifier).deleteAccount(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return authState.session != null
        ? CardWithActions(actions: _buildActions(context, ref, authState))
        : const SizedBox.shrink();
  }
}
