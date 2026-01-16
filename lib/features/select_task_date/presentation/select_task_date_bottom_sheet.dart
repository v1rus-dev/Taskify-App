import 'dart:io';

import 'package:design/design.dart';
import 'package:design/widgets/app_bottom_sheet.dart';
import 'package:design/widgets/app_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/time_format/time_format_notifier.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';
import 'package:taskify/core/utils/time_format_utils.dart';
import 'package:taskify/features/select_task_date/presentation/providers/select_task/select_task_notifier.dart';
import 'package:taskify/features/select_task_date/presentation/providers/select_task/select_task_state.dart';
import 'package:taskify/features/select_task_date/presentation/select_task_period_bottom_sheet.dart';

class SelectTaskDateBottomSheet extends ConsumerWidget {
  const SelectTaskDateBottomSheet({
    super.key,
    this.selectedDate,
    this.isAllDay,
    this.startTime,
    this.endTime,
    this.onSave,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;
  final void Function(
    DateTime selectedDate,
    bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  )?
  onSave;

  TaskDurationType _initialDurationType(bool? isAllDay) {
    return (isAllDay ?? true)
        ? TaskDurationType.allDay
        : TaskDurationType.period;
  }

  TimeOfDay? _initialTimeOfDay(DateTime? time) {
    if (time == null) {
      return null;
    }
    return TimeOfDay.fromDateTime(time);
  }

  Future<void> _onDatePressed(
    BuildContext context,
    SelectTaskNotifier notifier,
    DateTime initialDate,
  ) async {
    if (Platform.isIOS) {
      DateTime selected = initialDate;
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return Container(
            height: 320,
            padding: const EdgeInsets.only(top: 8),
            color: AppColorExtensions.getBackgroundColor(context),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextButton(
                    text: 'Done',
                    onPressed: () {
                      notifier.selectDate(selected);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    onDateTimeChanged: (date) {
                      selected = date;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      notifier.selectDate(picked);
    }
  }

  Future<void> _onDurationPressed(
    BuildContext context,
    SelectTaskNotifier notifier,
    TaskDurationType selectedType,
  ) async {
    await showAppModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      child: SelectTaskPeriodBottomSheet(
        selectedType: selectedType,
        onSelected: notifier.selectDurationType,
      ),
    );
  }

  Future<void> _onStartTimePressed(
    BuildContext context,
    SelectTaskNotifier notifier,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('use24Hour: $use24Hour');
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24Hour),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      notifier.selectStartTime(picked);
    }
  }

  Future<void> _onEndTimePressed(
    BuildContext context,
    SelectTaskNotifier notifier,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('use24Hour: $use24Hour');
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24Hour),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      notifier.selectEndTime(picked);
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(date);
  }

  List<CardAction> _buildCardActions(
    BuildContext context,
    SelectTaskState selectTaskState,
    SelectTaskNotifier selectTaskNotifier,
    bool isPeriod,
    bool use24Hour,
  ) {
    return [
      CardAction(
        title: 'Date',
        description: _formatDate(context, selectTaskState.selectedDate),
        onPressed: () => _onDatePressed(
          context,
          selectTaskNotifier,
          selectTaskState.selectedDate,
        ),
      ),
      CardAction(
        title: 'Period',
        description: selectTaskState.durationType == TaskDurationType.allDay
            ? 'All day'
            : 'Period',
        onPressed: () => _onDurationPressed(
          context,
          selectTaskNotifier,
          selectTaskState.durationType,
        ),
      ),
      if (isPeriod)
        CardAction(
          title: 'Start time',
          description: formatTimeOfDay(
            context,
            selectTaskState.startTime,
            use24Hour,
          ),
          onPressed: () => _onStartTimePressed(
            context,
            selectTaskNotifier,
            selectTaskState.startTime,
            use24Hour,
          ),
        ),
      if (isPeriod)
        CardAction(
          title: 'End time',
          description: formatTimeOfDay(
            context,
            selectTaskState.endTime,
            use24Hour,
          ),
          onPressed: () => _onEndTimePressed(
            context,
            selectTaskNotifier,
            selectTaskState.endTime,
            use24Hour,
          ),
        ),
    ];
  }

  void _onSavePressed(
    BuildContext context,
    SelectTaskState selectTaskState,
    SelectTaskNotifier selectTaskNotifier,
  ) {
    final startDateTime =
        selectTaskState.durationType == TaskDurationType.period &&
            selectTaskState.startTime != null
        ? DateTime(
            selectTaskState.selectedDate.year,
            selectTaskState.selectedDate.month,
            selectTaskState.selectedDate.day,
            selectTaskState.startTime!.hour,
            selectTaskState.startTime!.minute,
          )
        : null;
    final endDateTime =
        selectTaskState.durationType == TaskDurationType.period &&
            selectTaskState.endTime != null
        ? DateTime(
            selectTaskState.selectedDate.year,
            selectTaskState.selectedDate.month,
            selectTaskState.selectedDate.day,
            selectTaskState.endTime!.hour,
            selectTaskState.endTime!.minute,
          )
        : null;
    onSave?.call(
      selectTaskState.selectedDate,
      selectTaskState.durationType == TaskDurationType.allDay,
      startDateTime,
      endDateTime,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final initialDurationType = _initialDurationType(isAllDay);
    final initialStartTime = _initialTimeOfDay(startTime);
    final initialEndTime = _initialTimeOfDay(endTime);
    final selectTaskState = ref.watch(
      selectTaskNotifierProvider((
        selectedDate,
        initialDurationType,
        initialStartTime,
        initialEndTime,
      )),
    );
    final selectTaskNotifier = ref.read(
      selectTaskNotifierProvider((
        selectedDate,
        initialDurationType,
        initialStartTime,
        initialEndTime,
      )).notifier,
    );
    final isPeriod = selectTaskState.durationType == TaskDurationType.period;
    final use24Hour = ref.watch(timeFormatProvider).value?.use24Hour ?? true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(12),
                Text("When", style: theme.textTheme.displayMedium),
                const SizedBox(height: 24),
                CardWithActions(
                  actions: _buildCardActions(
                    context,
                    selectTaskState,
                    selectTaskNotifier,
                    isPeriod,
                    use24Hour,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(48),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: AppTextButton(
            text: "Save",
            onPressed: () =>
                _onSavePressed(context, selectTaskState, selectTaskNotifier),
          ),
        ),
      ],
    );
  }
}
