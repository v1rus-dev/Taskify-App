import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/features/home/presentation/screen/home_screen_notifier.dart';
import 'package:taskify/features/home/presentation/widgets/home_calendar_item.dart';

class HomeCalendarPart extends ConsumerStatefulWidget {
  const HomeCalendarPart({super.key});

  @override
  ConsumerState<HomeCalendarPart> createState() => _HomeCalendarPartState();
}

class _HomeCalendarPartState extends ConsumerState<HomeCalendarPart> {
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
    _calculateDateRange();
    _pageController = PageController(initialPage: _currentWeekIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _calculateDateRange() {
    final now = DateTime.now();
    
    // Минимальная дата для выбора: первое число месяца, который был два месяца назад
    _minSelectableDate = DateTime(now.year, now.month - 2, 1);
    
    // Максимальная дата для выбора: конец месяца через 2 месяца
    _maxSelectableDate = DateTime(now.year, now.month + 3, 0);
    
    // Начало календаря: начало недели предыдущего месяца (чтобы можно было скроллить назад на месяц)
    // Находим первый день предыдущего месяца
    final previousMonth = DateTime(now.year, now.month - 1, 1);
    // Находим начало недели, которая содержит первый день предыдущего месяца
    final daysFromMonday = previousMonth.weekday - 1;
    _startDate = previousMonth.subtract(Duration(days: daysFromMonday));
    
    // Конец календаря: конец недели, которая содержит последний день месяца через 2 месяца
    final lastDayOfFutureMonth = _maxSelectableDate;
    final daysToSunday = 7 - lastDayOfFutureMonth.weekday;
    _endDate = lastDayOfFutureMonth.add(Duration(days: daysToSunday));
    
    // Вычисляем количество недель
    final daysDifference = _endDate.difference(_startDate).inDays;
    _totalWeeks = (daysDifference / 7).ceil();
    
    // Вычисляем индекс текущей недели
    final today = DateTime.now();
    final todayStartOfWeek = today.subtract(Duration(days: today.weekday - 1));
    _currentWeekIndex = todayStartOfWeek.difference(_startDate).inDays ~/ 7;
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
    final state = ref.watch(homeScreenNotifierProvider);
    final notifier = ref.read(homeScreenNotifierProvider.notifier);
    final today = DateTime.now();

    return SizedBox(
      height: 70,
      child: PageView.builder(
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
                      isToday: weekDays[i].year == today.year &&
                          weekDays[i].month == today.month &&
                          weekDays[i].day == today.day,
                      isSelected: weekDays[i].year == state.selectedDate.year &&
                          weekDays[i].month == state.selectedDate.month &&
                          weekDays[i].day == state.selectedDate.day,
                      selectedBackgroundColor: Color(0xFF7990F8).withValues(alpha: 0.8),
                      selectedTextColor: Colors.white,
                      selectedBorderColor: Color(0xFF7990F8).withValues(alpha: 0.8),
                      unselectedTodayBorderColor: Color(0xFF7990F8).withValues(alpha: 0.8),
                      unselectedTextColor: Color(0xFF121212).withValues(alpha: 0.5),
                      unselectedBackgroundColor: Colors.white,
                      isDisabled: !_isDateSelectable(weekDays[i]),
                      onTap: _isDateSelectable(weekDays[i])
                          ? () => notifier.selectDate(weekDays[i])
                          : null,
                    ),
                  ),
                  if (i < weekDays.length - 1) const SizedBox(width: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
} 