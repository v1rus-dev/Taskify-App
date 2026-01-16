import 'dart:math';

import 'package:design/constants/app_icons.dart';
import 'package:design/themes/app_color_extensions.dart';
import 'package:design/widgets/app_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScreenAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(96);

  Widget _buildBackButton(BuildContext context) {
    final cardColor = AppColorExtensions.getCardColor(context);
    return AppShadow(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onBack ?? () => context.pop(),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Transform.rotate(
                angle: pi,
                child: SvgPicture.asset(
                  AppIcons.arrowRightSmall,
                  package: AppIcons.packageName,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaTop = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.only(
        top: safeAreaTop + 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(context),
          const Gap(12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
