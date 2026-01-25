import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/features/home/presentation/widgets/home_app_bar_button.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize {
    return Size.fromHeight(AppInsets.toolbarHeight);
  }

  void _onChangeCalendarState(BuildContext context) {
    context.read<HomeBloc>().add(HomeEvent.changeCalendarVisibility());
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: safeAreaTop, left: 20.0, right: 20.0),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Row(
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
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getMonthShort(context, state.selectedDate),
                      textAlign: TextAlign.left,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.black.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              HomeAppBarButton(
                svgIconPath: state.isHeaderExpanded
                    ? AppIcons.arrowTop
                    : AppIcons.arrowBottom,
                packageName: AppIcons.packageName,
                onPressed: () => _onChangeCalendarState(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
