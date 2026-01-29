import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/core/utils/time_format_utils.dart';
import 'package:taskify/domain/tasks/models/task_duration_type.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_period/select_task_period_bottom_sheet.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_time/select_time_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskDatePeriodCard extends StatelessWidget {
  const EditTaskDatePeriodCard({super.key});

  static const _defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const _defaultEndTime = TimeOfDay(hour: 10, minute: 0);

  Future<void> _onDatePressed(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final picked = await AppDateTimePicker.pickDate(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      context.read<EditTaskBloc>().add(EditTaskEvent.dateSelected(picked));
    }
  }

  Future<void> _onDurationPressed(
    BuildContext context,
    TaskDurationType selectedType,
  ) async {
    await showAppBottomSheet<void>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectTaskPeriodBottomSheet(
        selectedType: selectedType,
        onSelected: (type) {
          context.read<EditTaskBloc>().add(
            EditTaskEvent.durationTypeSelected(type),
          );
        },
      ),
    );
  }

  Future<void> _onTimePressed(
    BuildContext context,
    TimeOfDay? initialStartTime,
    TimeOfDay? initialEndTime,
  ) async {
    await showAppBottomSheet(
      context: context,
      type: AppBottomSheetType.fullScreen,
      child: SelectTimeBottomSheet(
        initialStartTime: initialStartTime ?? _defaultStartTime,
        initialEndTime: initialEndTime ?? _defaultEndTime,
        onTimesSelected: (startTime, endTime) {
          context.read<EditTaskBloc>().add(
            EditTaskEvent.timeRangeSelected(startTime, endTime),
          );
        },
      ),
    );
  }

  void _onClearPressed(BuildContext context) {
    context.read<EditTaskBloc>().add(
      const EditTaskEvent.dateSelectionCleared(),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(date);
  }

  TimeOfDay? _toTimeOfDay(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return TimeOfDay.fromDateTime(dateTime);
  }

  List<CardAction> _buildCardActions(
    BuildContext context,
    EditTaskState state,
    bool use24Hour,
  ) {
    final l10n = AppLocalizations.of(context);
    final durationType = state.isAllDay
        ? TaskDurationType.allDay
        : TaskDurationType.period;
    final startTime = _toTimeOfDay(state.startTime);
    final endTime = _toTimeOfDay(state.endTime);
    final isPeriod = durationType == TaskDurationType.period;
    return [
      CardAction(
        title: l10n?.date ?? '',
        description: _formatDate(context, state.selectedDate),
        onPressed: () => _onDatePressed(context, state.selectedDate),
      ),
      CardAction(
        title: l10n?.period ?? '',
        description: durationType == TaskDurationType.allDay
            ? l10n?.allDay ?? ''
            : l10n?.period ?? '',
        onPressed: () => _onDurationPressed(context, durationType),
      ),
      if (isPeriod)
        CardAction(
          title: l10n?.time ?? '',
          description:
              '${formatTimeOfDay(context, startTime, use24Hour)} - ${formatTimeOfDay(context, endTime, use24Hour)}',
          onPressed: () => _onTimePressed(context, startTime, endTime),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return CardWithActions(
          showAppShadow: false,
          actions: _buildCardActions(context, state, use24Hour),
          animatable: true,
        );
      },
    );
  }
}
