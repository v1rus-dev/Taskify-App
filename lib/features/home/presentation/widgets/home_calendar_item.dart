import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:design/design.dart';

class HomeCalendarItem extends StatefulWidget {
  const HomeCalendarItem({
    super.key,
    required this.date,
    required this.isToday,
    required this.isSelected,
    this.isDisabled = false,
    this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
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
  bool _didInitDependencies = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimations();
    if (_didInitDependencies) {
      _controller.forward(from: 0.0);
      return;
    }
    _controller.forward();
    _didInitDependencies = true;
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

    _backgroundColorAnimation = ColorTween(
      begin: _backgroundColorAnimation?.value ?? targetBackgroundColor,
      end: targetBackgroundColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textColorAnimation = ColorTween(
      begin: _textColorAnimation?.value ?? targetTextColor,
      end: targetTextColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Color _getBackgroundColor() {
    return widget.isSelected
        ? AppColorExtensions.getPrimaryAccentColor(context).withValues(alpha: 0.6)
        : Colors.transparent;
  }

  Color _getSecondaryTextColor() {
    return widget.isSelected
        ? Colors.white
        : AppColorExtensions.getTextSecondaryColor(context);
  }

  Color _getTextColor() {
    return widget.isSelected
        ? Colors.white
        : AppColorExtensions.getTextPrimaryColor(context);
  }

  String _getDayName() {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('EEE', locale).format(widget.date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShadow(
      enabled: widget.isSelected,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: _backgroundColorAnimation?.value ?? _getBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.none,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.isDisabled ? null : widget.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Gap(6),
                    Text(
                      _getDayName(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getSecondaryTextColor(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.date.day.toString(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _textColorAnimation?.value ?? _getTextColor(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(6)
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
