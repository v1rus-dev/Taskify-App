import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AccountPart extends StatelessWidget {
  const AccountPart({super.key});

  Future<void> _onSignOutPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final shouldSignOut = await showAppConfirmDialog(
      context: context,
      title: l10n?.exitFromAccount ?? '',
      description: l10n?.exitFromAccountConfirmDescription ?? '',
      confirmButtonTitle: l10n?.exitFromAccount,
    );

    if (shouldSignOut != true || !context.mounted) {
      return;
    }

    context.read<AuthCubit>().signOut();
  }

  Future<void> _onRemoveAccountPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final localizations = MaterialLocalizations.of(context);
    final shouldDeleteAccount = await showAppErrorDialog(
      context: context,
      title: l10n?.deleteAccount ?? '',
      description: l10n?.deleteAccountConfirmDescription ?? '',
      primaryButtonTitle: l10n?.deleteAccount,
      secondaryButtonTitle: localizations.cancelButtonLabel,
    );

    if (shouldDeleteAccount != true || !context.mounted) {
      return;
    }

    context.read<ProfileBloc>().add(const ProfileRemoveAccount());
  }

  List<CardWithActionsEntry> _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      CardActionEntry(
        CardAction(
          title: l10n?.exitFromAccount ?? '',
          icon: SvgPicture.asset(
            AppIcons.logout,
            package: AppIcons.packageName,
            width: 24,
            height: 24,
          ),
          showArrow: false,
          onPressed: () async => _onSignOutPressed(context),
        ),
      ),
      CardActionEntry(
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
          showArrow: false,
          titleColor: AppColorExtensions.getErrorColor(context),
          onPressed: () async => _onRemoveAccountPressed(context),
        ),
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
