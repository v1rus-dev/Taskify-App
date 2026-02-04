import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class FriendCodeValueCard extends StatelessWidget {
  const FriendCodeValueCard({super.key, required this.friendCode});

  final String friendCode;

  void _onPressed() {
    Clipboard.setData(ClipboardData(text: friendCode));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                friendCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(4),
              SvgPicture.asset(
                AppIcons.copy,
                package: AppIcons.packageName,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  AppColorExtensions.getIconColor(context),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
