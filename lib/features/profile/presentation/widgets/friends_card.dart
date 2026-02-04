import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:gap/gap.dart';

class FriendsCard extends StatelessWidget {
  const FriendsCard({super.key});

  void _onCardPressed(BuildContext context) {
    appRouter.push(RouterPaths.friendsList);
  }

  @override
  Widget build(BuildContext context) {
    return AppShadow(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onCardPressed(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.friends ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Gap(4),
                    Text(
                      AppLocalizations.of(context)?.addAndManageFriends ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColorExtensions.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  AppIcons.users,
                  package: AppIcons.packageName,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColorExtensions.getIconColor(context),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
