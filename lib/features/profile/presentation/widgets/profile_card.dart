import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/friend_code_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});

  final AuthUserModel user;

  void _onCardPressed(BuildContext context) {
    showAppBottomSheet(
      context: context,
      type: AppBottomSheetType.floating,
      child: FriendCodeBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user.name ?? user.email;
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
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RoundedSquareAvatar(
                    imageUrl: user.avatarUrl,
                    name: displayName,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? user.email,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.friendCode ?? '',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Color(0xFFA6A6A6)),
                          ),
                          const Gap(6),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            user.friendTag,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
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
