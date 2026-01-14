import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  DateCard({super.key, required this.date, required this.todayDate, required this.isSelected, required this.isWeakend, required this.widthBetweenCards});

  final DateTime date;
  final DateTime todayDate;
  final bool isSelected;
  final bool isWeakend;
  final double widthBetweenCards;

  final Color _selectedBackgroundColor = const Color(0xFF002FFF).withValues(alpha: 0.6);
  final Color _selectedTextColor = Colors.white;
  final Color _unselectedBackgroundColor = Colors.white;
  final Color _unselectedPreviousTextColor = const Color(0xFF121212).withValues(alpha: 0.4);
  final Color _unselectedNextTextColor = const Color(0xFF121212);
  final Color _weakendNextTextColor = const Color(0xFFD52626);
  final Color _weakendPreviousTextColor = const Color(0xFFD52626).withValues(alpha: 0.4);
  final Color _currentNotSelectedTextColor = const Color(0xFF002FFF).withValues(alpha: 0.6);
  final Color _currentNotSelectedDividerColor = const Color(0xFF002FFF).withValues(alpha: 0.6);
  

  bool get isToday => date.year == todayDate.year && date.month == todayDate.month && date.day == todayDate.day;

  DateType get dateType => isToday ? DateType.current : date.isBefore(todayDate) ? DateType.previous : DateType.next;

  Color get _backgroundColor {
    if (isSelected) return _selectedBackgroundColor;
    return _unselectedBackgroundColor;
  }

  Color get _textColor {
    if (isSelected) return _selectedTextColor;
    
    if (isWeakend) {
      return dateType == DateType.previous 
          ? _weakendPreviousTextColor 
          : _weakendNextTextColor;
    }
    
    if (dateType == DateType.current) {
      return _currentNotSelectedTextColor;
    }
    
    return dateType == DateType.previous 
        ? _unselectedPreviousTextColor 
        : _unselectedNextTextColor;
  }

  Color? get _borderColor {
    if (isSelected) return null;
    if (dateType == DateType.current) return _currentNotSelectedDividerColor;
    return const Color(0xFF121212).withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final sidePadding = 20.0;
        final availableWidth = screenWidth - (sidePadding * 2);
        
        final cardWidth = (availableWidth - (widthBetweenCards * 6)) / 7;
        final cardHeight = cardWidth * 1.2;

        return Material(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: _borderColor != null 
                    ? Border.all(color: _borderColor!, width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum DateType {
  previous,
  current,
  next,
}