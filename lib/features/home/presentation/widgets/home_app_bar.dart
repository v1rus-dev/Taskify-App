import 'package:design/constants/app_icons.dart';
import 'package:design/themes/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/home/presentation/providers/home_screen_notifier.dart';
import 'package:taskify/features/home/presentation/widgets/home_app_bar_button.dart';
import 'package:taskify/l10n/app_localizations.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize {
    // Минимальная высота: отступ 24 + Row высотой 44 = 68
    // SafeArea будет добавлен автоматически через padding
    // Используем достаточно большое значение для покрытия всех устройств
    return const Size.fromHeight(120);
  }

  void _openSettings() {
    appRouter.push(RouterPaths.settings);
  }

  void _onChangeCalendarState(WidgetRef ref) {
    ref.read(homeScreenNotifierProvider.notifier).changeCalendarState();
  }

  String _getDayShort(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final day = DateFormat('E', locale).format(date);
    final dayCapitalized = day.isNotEmpty
        ? '${day[0].toUpperCase()}${day.substring(1)}'
        : day;
    return '$dayCapitalized.';
  }

  String _getMonthShort(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return '${date.day} ${DateFormat('MMM', locale).format(date)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(homeScreenNotifierProvider);
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: safeAreaTop, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: SizedBox(
          height: 44.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    state.selectedDate.day == state.currentDate.day &&
                            state.selectedDate.month ==
                                state.currentDate.month &&
                            state.selectedDate.year == state.currentDate.year
                        ? AppLocalizations.of(context)?.today ?? ''
                        : _getDayShort(context, state.selectedDate),
                    textAlign: TextAlign.left,
                    style: theme.textTheme.displayLarge,
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getMonthShort(context, state.selectedDate),
                      textAlign: TextAlign.left,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.black.withOpacity(0.3),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  HomeAppBarButton(
                    svgIconPath: state.isHeaderExpanded
                        ? AppIcons.arrowTop
                        : AppIcons.arrowBottom,
                    packageName: AppIcons.packageName,
                    onPressed: () => _onChangeCalendarState(ref),
                  ),
                  const Gap(12),
                  HomeAppBarButton(
                    svgIconPath: AppIcons.settings,
                    packageName: AppIcons.packageName,
                    onPressed: _openSettings,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
