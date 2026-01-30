import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AccountPart extends StatelessWidget {
  const AccountPart({super.key});

  void _onSignOutPressed(BuildContext context) {
    context.read<AuthCubit>().signOut();
  }

  void _onRemoveAccountPressed(BuildContext context) {
    context.read<ProfileBloc>().add(const ProfileRemoveAccount());
  }

  List<CardAction> _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      CardAction(
        title: l10n?.exitFromAccount ?? '',
        icon: SvgPicture.asset(
          AppIcons.logout,
          package: AppIcons.packageName,
          width: 24,
          height: 24,
        ),
        onPressed: () => _onSignOutPressed(context),
      ),
      CardAction(
        title: l10n?.deleteAccount ?? '',
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
        onPressed: () => _onRemoveAccountPressed(context),
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
