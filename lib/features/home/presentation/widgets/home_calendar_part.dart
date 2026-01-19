import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';
import 'package:taskify/features/home/presentation/widgets/home_calendar_item.dart';

class HomeCalendarPart extends StatefulWidget {
  const HomeCalendarPart({super.key});

  @override
  State<HomeCalendarPart> createState() => _HomeCalendarPartState();
}

class _HomeCalendarPartState extends State<HomeCalendarPart> {
  late PageController _pageController;
  late DateTime _minSelectableDate;
  late DateTime _maxSelectableDate;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalWeeks;
  late int _currentWeekIndex;

  @override
  void initState() {
    super.initState();
    final selectedDate = context.read<HomeBloc>().state.selectedDate;
    _calculateDateRange(selectedDate);
    _pageController = PageController(initialPage: _currentWeekIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _calculateDateRange(DateTime baseDate) {
    final base = DateTime(baseDate.year, baseDate.month, baseDate.day);

    _minSelectableDate = DateTime(base.year, base.month - 2, 1);

    _maxSelectableDate = DateTime(base.year, base.month + 3, 0);

    final previousMonth = DateTime(base.year, base.month - 1, 1);
    final daysFromMonday = previousMonth.weekday - 1;
    _startDate = previousMonth.subtract(Duration(days: daysFromMonday));

    final lastDayOfFutureMonth = _maxSelectableDate;
    final daysToSunday = 7 - lastDayOfFutureMonth.weekday;
    _endDate = lastDayOfFutureMonth.add(Duration(days: daysToSunday));

    final daysDifference = _endDate.difference(_startDate).inDays;
    _totalWeeks = (daysDifference / 7).ceil();

    final selectedStartOfWeek = base.subtract(Duration(days: base.weekday - 1));
    _currentWeekIndex = selectedStartOfWeek.difference(_startDate).inDays ~/ 7;
  }

  List<DateTime> _getWeekDays(int weekIndex) {
    final weekStart = _startDate.add(Duration(days: weekIndex * 7));
    return List.generate(7, (index) {
      return weekStart.add(Duration(days: index));
    });
  }

  bool _isDateSelectable(DateTime date) {
    return date.isAfter(_minSelectableDate.subtract(const Duration(days: 1))) &&
        date.isBefore(_maxSelectableDate.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return SizedBox(
      height: 70,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return PageView.builder(
            clipBehavior: Clip.none,
            controller: _pageController,
            physics: const PageScrollPhysics(),
            itemCount: _totalWeeks,
            itemBuilder: (context, index) {
              final weekDays = _getWeekDays(index);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (int i = 0; i < weekDays.length; i++) ...[
                      Expanded(
                        child: HomeCalendarItem(
                          date: weekDays[i],
                          isToday:
                              weekDays[i].year == today.year &&
                              weekDays[i].month == today.month &&
                              weekDays[i].day == today.day,
                          isSelected:
                              weekDays[i].year == state.selectedDate.year &&
                              weekDays[i].month == state.selectedDate.month &&
                              weekDays[i].day == state.selectedDate.day,
                          selectedBackgroundColor: Color(
                            0xFF7990F8,
                          ).withValues(alpha: 0.8),
                          selectedTextColor: Colors.white,
                          selectedBorderColor: Color(
                            0xFF7990F8,
                          ).withValues(alpha: 0.8),
                          unselectedTodayBorderColor: Color(
                            0xFF7990F8,
                          ).withValues(alpha: 0.8),
                          unselectedTextColor: Color(
                            0xFF121212,
                          ).withValues(alpha: 0.5),
                          unselectedBackgroundColor: Colors.white,
                          isDisabled: !_isDateSelectable(weekDays[i]),
                          onTap: _isDateSelectable(weekDays[i])
                              ? () => context.read<HomeBloc>().add(HomeEvent.selectDate(weekDays[i]))
                              : null,
                        ),
                      ),
                      if (i < weekDays.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
