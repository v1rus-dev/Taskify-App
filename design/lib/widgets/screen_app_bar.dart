import 'dart:io';

import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScreenAppBar({
    super.key,
    required this.title,
    this.trailingWidget,
    this.onBack,
  });

  final String title;
  final Widget? trailingWidget;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaTop = MediaQuery.paddingOf(context).top;
    final isIos = Platform.isIOS;

    return Container(
      padding: EdgeInsets.only(top: safeAreaTop),
      color: theme.scaffoldBackgroundColor,
      child: SizedBox(
        height: AppInsets.toolbarHeight,
        child: Padding(
          padding: EdgeInsets.only(left: onBack != null ? 8 : 20, right: trailingWidget != null ? 8 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (onBack != null) ...[
                IconButton(
                  onPressed: onBack,
                  icon: SvgPicture.asset(
                    isIos ? AppIcons.arrowBackIos : AppIcons.arrowBackAndroid,
                    package: AppIcons.packageName,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Gap(8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (trailingWidget != null) ...[trailingWidget!],
            ],
          ),
        ),
      ),
    );
  }
}
