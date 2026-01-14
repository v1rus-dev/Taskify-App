import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/calendar/calendar_notifier.dart';
import '../providers/select_task/select_task_notifier.dart';

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.isWeekend,
    required this.isToday,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isSelected;
  final bool isWeekend;
  final bool isToday;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    final selectedBackgroundColor = const Color(0xFF002FFF).withValues(alpha: 0.6);
    final selectedTextColor = Colors.white;
    final unselectedBackgroundColor = Colors.white;
    final unselectedPreviousTextColor = const Color(0xFF121212).withValues(alpha: 0.4);
    final unselectedNextTextColor = const Color(0xFF121212);
    final weekendNextTextColor = const Color(0xFFD52626);
    final weekendPreviousTextColor = const Color(0xFFD52626).withValues(alpha: 0.4);
    final currentNotSelectedTextColor = const Color(0xFF002FFF).withValues(alpha: 0.6);
    final currentNotSelectedDividerColor = const Color(0xFF002FFF).withValues(alpha: 0.6);

    Color backgroundColor;
    Color textColor;
    Color? borderColor;

    if (isSelected) {
      backgroundColor = selectedBackgroundColor;
      textColor = selectedTextColor;
      borderColor = null;
    } else {
      backgroundColor = unselectedBackgroundColor;
      
      if (isWeekend) {
        textColor = isCurrentMonth
            ? weekendNextTextColor
            : weekendPreviousTextColor;
      } else if (isToday) {
        textColor = currentNotSelectedTextColor;
        borderColor = currentNotSelectedDividerColor;
      } else {
        textColor = isCurrentMonth
            ? unselectedNextTextColor
            : unselectedPreviousTextColor;
      }
      
      if (borderColor == null && !isToday) {
        borderColor = const Color(0xFF121212).withValues(alpha: 0.1);
      }
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.isAllDay,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final calendarNotifier = ref.read(calendarNotifierProvider.notifier);
    final selectTaskState = ref.watch(
      selectTaskNotifierProvider((selectedDate, isAllDay)),
    );
    final selectTaskNotifier = ref.read(
      selectTaskNotifierProvider((selectedDate, isAllDay)).notifier,
    );

    final currentMonth = calendarState.dateTime;
    final today = DateTime.now();
    final selectedDateValue = selectTaskState.selectedDate;

    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );

    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    final List<DateTime> calendarDays = [];

    final startOffset = firstDayWeekday - 1;
    for (int i = 0; i < startOffset; i++) {
      final prevMonthDate = firstDayOfMonth.subtract(Duration(days: startOffset - i));
      calendarDays.add(prevMonthDate);
    }

    for (int day = 1; day <= daysInMonth; day++) {
      calendarDays.add(DateTime(currentMonth.year, currentMonth.month, day));
    }

    final remainingDays = 35 - calendarDays.length;
    for (int day = 1; day <= remainingDays; day++) {
      calendarDays.add(DateTime(currentMonth.year, currentMonth.month + 1, day));
    }

    final firstVisibleMonth = calendarDays.first;
    final isSelectedDateVisible = calendarDays.any((date) =>
        date.year == selectedDateValue.year &&
        date.month == selectedDateValue.month &&
        date.day == selectedDateValue.day);

    final displayMonth = isSelectedDateVisible
        ? selectedDateValue
        : firstVisibleMonth;

    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthYearText = DateFormat('MMMM yyyy', locale).format(displayMonth);

    final weekDays = List.generate(7, (index) {
      final weekday = index + 1;
      final baseDate = DateTime(2024, 1, 1);
      final date = baseDate.add(Duration(days: weekday - baseDate.weekday));
      final dayName = DateFormat('EEE', locale).format(date);
      return dayName.length > 3 ? dayName.substring(0, 3) : dayName;
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => calendarNotifier.goToPreviousMonth(),
              icon: const Icon(Icons.arrow_left),
            ),
            Text(
              monthYearText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () => calendarNotifier.goToNextMonth(),
              icon: const Icon(Icons.arrow_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF121212),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final padding = 40.0;
            final availableWidth = screenWidth - padding;
            final cellWidth = (availableWidth - (8 * 6)) / 7;
            final gridHeight = (cellWidth * 5) + (8 * 4);

            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: 35,
                itemBuilder: (context, index) {
              final date = calendarDays[index];
              final isSelected = date.year == selectedDateValue.year &&
                  date.month == selectedDateValue.month &&
                  date.day == selectedDateValue.day;
              final isWeekend = date.weekday == 6 || date.weekday == 7;
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isCurrentMonth = date.month == currentMonth.month &&
                  date.year == currentMonth.year;

              return GestureDetector(
                onTap: () {
                  selectTaskNotifier.selectDate(date);
                  calendarNotifier.setDate(date);
                },
                child: _CalendarDayCell(
                  date: date,
                  isSelected: isSelected,
                  isWeekend: isWeekend,
                  isToday: isToday,
                  isCurrentMonth: isCurrentMonth,
                ),
              );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}