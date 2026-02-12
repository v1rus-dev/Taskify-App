import 'package:design/constants/app_insets.dart';
import 'package:design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/select_time/widgets/select_time_picker.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectTimeBottomSheet extends StatefulWidget {
  const SelectTimeBottomSheet({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
    this.onTimesSelected,
  });

  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final void Function(TimeOfDay startTime, TimeOfDay endTime)? onTimesSelected;

  @override
  State<SelectTimeBottomSheet> createState() => _SelectTimeBottomSheetState();
}

class _SelectTimeBottomSheetState extends State<SelectTimeBottomSheet> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStartTime ?? TimeOfDay.now();
    final computedEndTime =
        widget.initialEndTime ?? _defaultEndTimeFor(_startTime);
    _endTime = _coerceEndTime(computedEndTime, _startTime);
  }

  void _onSavePressed(BuildContext context) {
    widget.onTimesSelected?.call(_startTime, _endTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );
    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        children: [
          const Gap(12),
          Text(
            l10n?.selectTimes ?? '',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    l10n?.from ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SelectTimePicker(
                    initialTime: _startTime,
                    mode: SelectTimePickerMode.start,
                    currentStartTime: _startTime,
                    currentEndTime: _endTime,
                    use24hFormat: use24Hour,
                    canSelectPastTime: true,
                    onTimeChanged: _handleStartTimeChanged,
                  ),
                  const Gap(12),
                  Text(
                    l10n?.to ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SelectTimePicker(
                    initialTime: _endTime,
                    mode: SelectTimePickerMode.end,
                    currentStartTime: _startTime,
                    currentEndTime: _endTime,
                    use24hFormat: use24Hour,
                    canSelectPastTime: false,
                    onTimeChanged: _handleEndTimeChanged,
                  ),
                ],
              ),
            ),
          ),
          const Gap(12),
          AppTextButton(
            text: l10n?.save ?? '',
            onPressed: () => _onSavePressed(context),
          ),
          const Gap(AppInsets.sheetBottomSmall),
        ],
      ),
    );
  }

  TimeOfDay _coerceEndTime(TimeOfDay endTime, TimeOfDay startTime) {
    if (_isBefore(endTime, startTime)) {
      return startTime;
    }
    return endTime;
  }

  TimeOfDay _defaultEndTimeFor(TimeOfDay startTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = startMinutes + 60;
    if (endMinutes < 24 * 60) {
      return TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);
    }
    return startTime;
  }

  bool _isBefore(TimeOfDay lhs, TimeOfDay rhs) {
    final lhsMinutes = lhs.hour * 60 + lhs.minute;
    final rhsMinutes = rhs.hour * 60 + rhs.minute;
    return lhsMinutes < rhsMinutes;
  }

  void _handleStartTimeChanged(TimeOfDay time) {
    setState(() {
      _startTime = time;
      if (_isBefore(_endTime, _startTime)) {
        _endTime = _startTime;
        _onEndTimeChanged(_endTime);
      }
    });
    _onStartTimeChanged(time);
  }

  void _handleEndTimeChanged(TimeOfDay time) {
    if (_isBefore(time, _startTime)) {
      setState(() {
        _endTime = _startTime;
      });
      _onEndTimeChanged(_endTime);
      return;
    }
    setState(() {
      _endTime = time;
    });
    _onEndTimeChanged(time);
  }

  void _onStartTimeChanged(TimeOfDay time) {
    widget.onTimesSelected?.call(time, _endTime);
  }

  void _onEndTimeChanged(TimeOfDay time) {
    widget.onTimesSelected?.call(_startTime, time);
  }
}
