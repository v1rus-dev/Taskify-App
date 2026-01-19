import 'package:flutter/material.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScreenAppBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(96);

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
          Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
        ],
      ),
    );
  }
}
