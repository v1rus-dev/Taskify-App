import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/l10n/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});

  final AuthUserModel user;

  void _onCardPressed(BuildContext context) {}

  void _onCopyFriendCodePressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: user.friendTag));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.friendCodeCopied ?? '',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user.name ?? user.email;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onCardPressed(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        GestureDetector(
                          onTap: () => _onCopyFriendCodePressed(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                user.friendTag,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const Gap(4),
                              SvgPicture.asset(
                                AppIcons.copy,
                                package: AppIcons.packageName,
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  Color(0xFFC9C9C9),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
