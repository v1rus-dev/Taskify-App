import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/auth/auth_notifier.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPart extends StatelessWidget {
  const AccountPart({super.key});

  List<CardAction> _buildActions(BuildContext context) {
    return [
      CardAction(
        title: 'Exit from account',
        icon: SvgPicture.asset(
          AppIcons.logout,
          package: AppIcons.packageName,
          width: 24,
          height: 24,
        ),
        onPressed: () => context.read<AuthCubit>().signOut(),
      ),
      CardAction(
        title: 'Delete account',
        icon: SvgPicture.asset(
          AppIcons.trash,
          package: AppIcons.packageName,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            AppColorExtensions.getErrorColor(context),
            BlendMode.srcIn,
          ),
        ),
        titleColor: AppColorExtensions.getErrorColor(context),
        onPressed: () => {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final session = context.select((AuthCubit c) => c.state.session);

    if (session == null) return const SizedBox.shrink();

    return CardWithActions(actions: _buildActions(context));
  }
}
