import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:design/design.dart';

class HomeCalendarItem extends StatefulWidget {
  const HomeCalendarItem({
    super.key,
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.selectedBorderColor,
    required this.selectedTextColor,
    required this.selectedBackgroundColor,
    required this.unselectedTodayBorderColor,
    required this.unselectedTextColor,
    required this.unselectedBackgroundColor,
    this.isDisabled = false,
    this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
  final Color selectedBorderColor;
  final Color selectedTextColor;
  final Color selectedBackgroundColor;
  final Color unselectedTodayBorderColor;
  final Color unselectedTextColor;
  final Color unselectedBackgroundColor;
  final VoidCallback? onTap;

  @override
  State<HomeCalendarItem> createState() => _HomeCalendarItemState();
}

class _HomeCalendarItemState extends State<HomeCalendarItem>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 200);

  late AnimationController _controller;
  Animation<Color?>? _backgroundColorAnimation;
  Animation<Color?>? _textColorAnimation;
  Animation<Color?>? _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _updateAnimations();
    _controller.forward();
  }

  @override
  void didUpdateWidget(HomeCalendarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected ||
        oldWidget.isToday != widget.isToday) {
      _updateAnimations();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAnimations() {
    final targetBackgroundColor = _getBackgroundColor();
    final targetTextColor = _getTextColor();
    final targetBorderColor = _getBorderColor();

    _backgroundColorAnimation = ColorTween(
      begin: _backgroundColorAnimation?.value ?? targetBackgroundColor,
      end: targetBackgroundColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textColorAnimation = ColorTween(
      begin: _textColorAnimation?.value ?? targetTextColor,
      end: targetTextColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _borderColorAnimation = ColorTween(
      begin: _borderColorAnimation?.value ?? targetBorderColor,
      end: targetBorderColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Color _getBackgroundColor() {
    if (widget.isToday) {
      if (widget.isSelected) {
        return widget.selectedBackgroundColor;
      } else {
        return widget.unselectedBackgroundColor;
      }
    } else {
      if (widget.isSelected) {
        return widget.selectedBackgroundColor;
      } else {
        return widget.unselectedBackgroundColor;
      }
    }
  }

  Color _getTextColor() {
    if (widget.isSelected) {
      return widget.selectedTextColor;
    } else {
      return widget.unselectedTextColor;
    }
  }

  Color _getBorderColor() {
    if (widget.isToday) {
      if (widget.isSelected) {
        return Colors.transparent;
      } else {
        return widget.selectedBorderColor;
      }
    } else {
      return Colors.transparent;
    }
  }

  String _getDayName() {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('EEE', locale).format(widget.date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShadow(
      borderRadius: BorderRadius.circular(12),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: _backgroundColorAnimation?.value ?? _getBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
              border: widget.isToday && !widget.isSelected
                  ? Border.all(
                      color: _borderColorAnimation?.value ?? _getBorderColor(),
                      width: 1,
                    )
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.none,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.isDisabled ? null : widget.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _getDayName(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _textColorAnimation?.value ?? _getTextColor(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.date.day.toString(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: _textColorAnimation?.value ?? _getTextColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
