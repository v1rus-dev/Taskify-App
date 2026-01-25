import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SelectTimePickerMode {
  start,
  end,
}

class SelectTimePicker extends StatefulWidget {
  const SelectTimePicker({
    super.key,
    required this.mode,
    required this.initialTime,
    required this.currentStartTime,
    required this.currentEndTime,
    required this.use24hFormat,
    required this.canSelectPastTime,
    required this.onTimeChanged,
  });

  final SelectTimePickerMode mode;
  final TimeOfDay initialTime;
  final TimeOfDay? currentStartTime;
  final TimeOfDay? currentEndTime;
  final bool use24hFormat;
  final bool canSelectPastTime;
  final void Function(TimeOfDay) onTimeChanged;

  @override
  State<SelectTimePicker> createState() => _SelectTimePickerState();
}

class _SelectTimePickerState extends State<SelectTimePicker> {
  static const _itemExtent = 56.0;
  static const _pickerWidth = 64.0;
  static const _periodWidth = 72.0;
  static const _selectionBoxSize = 56.0;
  static const _scrollDuration = Duration(milliseconds: 250);
  static const _scrollCurve = Curves.easeInOut;

  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _periodController;

  ValueNotifier<bool>? _hoursScrollingNotifier;
  ValueNotifier<bool>? _minutesScrollingNotifier;
  ValueNotifier<bool>? _periodScrollingNotifier;
  bool _isHourScrolling = false;
  bool _isMinuteScrolling = false;
  bool _isPeriodScrolling = false;

  late int _selectedHourIndex;
  late int _selectedMinuteIndex;
  late int _selectedPeriodIndex;
  bool _isAutoScrolling = false;

  List<int> get _hourValues {
    if (widget.use24hFormat) {
      return List.generate(24, (index) => index);
    }
    return List.generate(12, (index) => index + 1);
  }

  List<String> get _periodValues => const ['AM', 'PM'];

  @override
  void initState() {
    super.initState();
    _selectedHourIndex = _initialHourIndex;
    _selectedMinuteIndex = widget.initialTime.minute;
    _selectedPeriodIndex = _initialPeriodIndex;
    _hoursController = FixedExtentScrollController(
      initialItem: _selectedHourIndex,
    );
    _minutesController = FixedExtentScrollController(
      initialItem: _selectedMinuteIndex,
    );
    _periodController = FixedExtentScrollController(
      initialItem: _selectedPeriodIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _attachScrollListeners();
    });
  }

  @override
  void didUpdateWidget(covariant SelectTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final didFormatChange = oldWidget.use24hFormat != widget.use24hFormat;
    final didInitialChange = oldWidget.initialTime != widget.initialTime;
    final oldMinimumTime = _resolveMinimumTime(oldWidget);
    final newMinimumTime = _minimumTime;
    final didMinimumChange = oldMinimumTime != newMinimumTime;
    if (didFormatChange || didInitialChange) {
      _scrollToInitialTime();
      return;
    }
    if (didMinimumChange) {
      final hour24 = _selectedHour24;
      final minute = _selectedMinuteIndex;
      if (_isBeforeMinimum(hour24, minute)) {
        _scrollToMinimumTime();
      }
    }
  }

  @override
  void dispose() {
    _detachScrollListeners();
    _hoursController.dispose();
    _minutesController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _attachScrollListeners() {
    _hoursScrollingNotifier = _hoursController.position.isScrollingNotifier;
    _minutesScrollingNotifier = _minutesController.position.isScrollingNotifier;
    if (!widget.use24hFormat) {
      _periodScrollingNotifier = _periodController.position.isScrollingNotifier;
    }

    _hoursScrollingNotifier?.addListener(_onScrollingChanged);
    _minutesScrollingNotifier?.addListener(_onScrollingChanged);
    if (!widget.use24hFormat) {
      _periodScrollingNotifier?.addListener(_onScrollingChanged);
    }
  }

  void _detachScrollListeners() {
    _hoursScrollingNotifier?.removeListener(_onScrollingChanged);
    _minutesScrollingNotifier?.removeListener(_onScrollingChanged);
    _periodScrollingNotifier?.removeListener(_onScrollingChanged);
  }

  void _onScrollingChanged() {
    _isHourScrolling = _hoursScrollingNotifier?.value ?? false;
    _isMinuteScrolling = _minutesScrollingNotifier?.value ?? false;
    _isPeriodScrolling = _periodScrollingNotifier?.value ?? false;

    final isAnyScrolling =
        _isHourScrolling ||
        _isMinuteScrolling ||
        (!widget.use24hFormat && _isPeriodScrolling);
    if (!isAnyScrolling) {
      _handleScrollEnd();
    }
  }

  int get _initialHourIndex {
    if (widget.use24hFormat) {
      return widget.initialTime.hour;
    }
    final displayHour = widget.initialTime.hour % 12 == 0
        ? 12
        : widget.initialTime.hour % 12;
    return displayHour - 1;
  }

  int get _initialPeriodIndex => widget.initialTime.hour >= 12 ? 1 : 0;

  int get _selectedHourValue => _hourValues[_selectedHourIndex];

  int get _selectedHour24 {
    if (widget.use24hFormat) {
      return _selectedHourValue;
    }
    return _to24Hour(_selectedHourValue, _selectedPeriodIndex);
  }

  int _to24Hour(int displayHour, int periodIndex) {
    final normalizedHour = displayHour % 12;
    if (periodIndex == 0) {
      return normalizedHour;
    }
    return normalizedHour + 12;
  }

  TimeOfDay get _minimumTime => _resolveMinimumTime(widget);

  int get _minimumTotalMinutes =>
      _minimumTime.hour * 60 + _minimumTime.minute;

  bool _isBeforeMinimum(int hour24, int minute) {
    return (hour24 * 60 + minute) < _minimumTotalMinutes;
  }

  bool _isValidSelection(int hour24, int minute) {
    if (widget.canSelectPastTime) {
      return true;
    }
    return !_isBeforeMinimum(hour24, minute);
  }

  TimeOfDay _resolveMinimumTime(SelectTimePicker picker) {
    if (picker.mode == SelectTimePickerMode.end &&
        picker.currentStartTime != null) {
      return picker.currentStartTime!;
    }
    return picker.initialTime;
  }

  Future<void> _scrollToInitialTime() async {
    if (_isAutoScrolling) {
      return;
    }
    _isAutoScrolling = true;
    final hourIndex = _initialHourIndex;
    final minuteIndex = widget.initialTime.minute;
    final periodIndex = _initialPeriodIndex;
    await Future.wait([
      _hoursController.animateToItem(
        hourIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      _minutesController.animateToItem(
        minuteIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      if (!widget.use24hFormat)
        _periodController.animateToItem(
          periodIndex,
          duration: _scrollDuration,
          curve: _scrollCurve,
        ),
    ]);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedHourIndex = hourIndex;
      _selectedMinuteIndex = minuteIndex;
      _selectedPeriodIndex = periodIndex;
    });
    widget.onTimeChanged(widget.initialTime);
    _isAutoScrolling = false;
  }

  Future<void> _scrollToMinimumTime() async {
    if (_isAutoScrolling) {
      return;
    }
    _isAutoScrolling = true;
    final time = _minimumTime;
    final displayHour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final hourIndex = widget.use24hFormat ? time.hour : displayHour - 1;
    final minuteIndex = time.minute;
    final periodIndex = time.hour >= 12 ? 1 : 0;
    await Future.wait([
      _hoursController.animateToItem(
        hourIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      _minutesController.animateToItem(
        minuteIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      if (!widget.use24hFormat)
        _periodController.animateToItem(
          periodIndex,
          duration: _scrollDuration,
          curve: _scrollCurve,
        ),
    ]);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedHourIndex = hourIndex;
      _selectedMinuteIndex = minuteIndex;
      _selectedPeriodIndex = periodIndex;
    });
    widget.onTimeChanged(time);
    _isAutoScrolling = false;
  }

  Future<void> scrollToInitialTime() async {
    if (_isAutoScrolling) {
      return;
    }
    _isAutoScrolling = true;

    final hourIndex = _initialHourIndex;
    final minuteIndex = widget.initialTime.minute;
    final periodIndex = _initialPeriodIndex;

    await Future.wait([
      _hoursController.animateToItem(
        hourIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      _minutesController.animateToItem(
        minuteIndex,
        duration: _scrollDuration,
        curve: _scrollCurve,
      ),
      if (!widget.use24hFormat)
        _periodController.animateToItem(
          periodIndex,
          duration: _scrollDuration,
          curve: _scrollCurve,
        ),
    ]);

    if (!mounted) {
      return;
    }
    setState(() {
      _selectedHourIndex = hourIndex;
      _selectedMinuteIndex = minuteIndex;
      _selectedPeriodIndex = periodIndex;
    });
    widget.onTimeChanged(widget.initialTime);
    _isAutoScrolling = false;
  }

  void _onHourChanged(int index) {
    if (_isAutoScrolling) {
      return;
    }
    setState(() {
      _selectedHourIndex = index;
    });
  }

  void _onMinuteChanged(int index) {
    if (_isAutoScrolling) {
      return;
    }
    setState(() {
      _selectedMinuteIndex = index;
    });
  }

  void _onPeriodChanged(int index) {
    if (_isAutoScrolling) {
      return;
    }
    setState(() {
      _selectedPeriodIndex = index;
    });
  }

  void _handleScrollEnd() {
    if (_isAutoScrolling) {
      return;
    }
    final hour24 = _selectedHour24;
    final minute = _selectedMinuteIndex;
    if (!_isValidSelection(hour24, minute)) {
      _scrollToMinimumTime();
      return;
    }
    widget.onTimeChanged(TimeOfDay(hour: hour24, minute: minute));
  }

  String _formatTwoDigits(int value) => value.toString().padLeft(2, '0');

  Color _itemColor(BuildContext context, bool isEnabled) {
    if (isEnabled) {
      return AppColorExtensions.getTextPrimaryColor(context);
    }
    return AppColorExtensions.getTextSecondaryColor(
      context,
    ).withValues(alpha: 0.45);
  }

  TextStyle _itemTextStyle(BuildContext context, bool isEnabled) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();
    final baseStyle =
        typography?.titleMedium ?? Theme.of(context).textTheme.titleMedium;
    return (baseStyle ?? const TextStyle()).copyWith(
      color: _itemColor(context, isEnabled),
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildPickerItem({
    required BuildContext context,
    required String text,
    required bool isEnabled,
  }) {
    return Center(
      child: SizedBox(
        width: _selectionBoxSize,
        height: _selectionBoxSize,
        child: Center(
          child: Text(
            text,
            style: _itemTextStyle(context, isEnabled),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOverlay(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: _selectionBoxSize,
          height: _selectionBoxSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorExtensions.getDividerColor(
                context,
              ).withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required bool Function(int) isEnabled,
    required ValueChanged<int> onSelectedItemChanged,
    double width = _pickerWidth,
  }) {
    return SizedBox(
      width: width,
      height: _itemExtent * 5,
      child: CupertinoPicker.builder(
        scrollController: controller,
        itemExtent: _itemExtent,
        magnification: 1.0,
        useMagnifier: false,
        onSelectedItemChanged: onSelectedItemChanged,
        selectionOverlay: _buildSelectionOverlay(context),
        childCount: itemCount,
        itemBuilder: (context, index) {
          return _buildPickerItem(
            context: context,
            text: labelBuilder(index),
            isEnabled: isEnabled(index),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hourValues = _hourValues;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWheel(
          controller: _hoursController,
          itemCount: hourValues.length,
          labelBuilder: (index) => _formatTwoDigits(hourValues[index]),
          isEnabled: (index) {
            if (widget.canSelectPastTime) {
              return true;
            }
            final hour24 = widget.use24hFormat
                ? hourValues[index]
                : _to24Hour(hourValues[index], _selectedPeriodIndex);
            return !_isBeforeMinimum(hour24, _selectedMinuteIndex);
          },
          onSelectedItemChanged: _onHourChanged,
        ),
        SizedBox(
          width: 16,
          child: Center(child: Text(':', style: _itemTextStyle(context, true))),
        ),
        _buildWheel(
          controller: _minutesController,
          itemCount: 60,
          labelBuilder: (index) => _formatTwoDigits(index),
          isEnabled: (index) {
            if (widget.canSelectPastTime) {
              return true;
            }
            return !_isBeforeMinimum(_selectedHour24, index);
          },
          onSelectedItemChanged: _onMinuteChanged,
        ),
        if (!widget.use24hFormat) ...[
          const SizedBox(width: 12),
          _buildWheel(
            controller: _periodController,
            itemCount: _periodValues.length,
            labelBuilder: (index) => _periodValues[index],
            isEnabled: (index) {
              if (widget.canSelectPastTime) {
                return true;
              }
              final hour24 = _to24Hour(_selectedHourValue, index);
              return !_isBeforeMinimum(hour24, _selectedMinuteIndex);
            },
            onSelectedItemChanged: _onPeriodChanged,
            width: _periodWidth,
          ),
        ],
      ],
    );
  }
}
