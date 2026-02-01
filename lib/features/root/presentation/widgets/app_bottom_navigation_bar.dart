import 'dart:ui';

import 'package:design/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/root/presentation/widgets/app_add_action_button.dart';
import 'package:taskify/features/root/presentation/widgets/app_navigation_button.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  void _goIfNotCurrent(String path) {
    if (appRouter.state.uri.path == path) {
      return;
    }

    appRouter.go(path);
  }

  void _pushIfNotCurrent(String path) {
    if (appRouter.state.uri.path == path) {
      return;
    }

    appRouter.push(path);
  }

  void _onAddPressed() {
    _pushIfNotCurrent(RouterPaths.editTask);
  }

  void _onHomePressed() {
    _goIfNotCurrent(RouterPaths.home);
  }

  void _onProfilePressed() {
    _goIfNotCurrent(RouterPaths.profile);
  }

  void _onSpacesPressed() {
    _goIfNotCurrent(RouterPaths.spaces);
  }

  void _onActivityPressed() {
    _goIfNotCurrent(RouterPaths.activity);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppNavigationButton(
                  title: l10n?.home ?? '',
                  iconPath: AppIcons.home,
                  packageName: AppIcons.packageName,
                  isSelected: appRouter.state.uri.path == RouterPaths.home,
                  onPressed: _onHomePressed,
                ),
                AppNavigationButton(
                  title: l10n?.spaces ?? '',
                  iconPath: AppIcons.saturn,
                  packageName: AppIcons.packageName,
                  isSelected: appRouter.state.uri.path == RouterPaths.spaces,
                  onPressed: _onSpacesPressed,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppAddActionButton(onPressed: _onAddPressed),
                ),
                AppNavigationButton(
                  title: l10n?.activity ?? '',
                  iconPath: AppIcons.chart,
                  packageName: AppIcons.packageName,
                  isSelected: appRouter.state.uri.path == RouterPaths.activity,
                  onPressed: _onActivityPressed,
                ),
                AppNavigationButton(
                  title: l10n?.profile ?? '',
                  iconPath: AppIcons.profile,
                  packageName: AppIcons.packageName,
                  isSelected: appRouter.state.uri.path == RouterPaths.profile,
                  onPressed: _onProfilePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
