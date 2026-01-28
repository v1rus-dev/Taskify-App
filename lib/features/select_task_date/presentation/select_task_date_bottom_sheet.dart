import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/time_format_utils.dart';
import 'package:taskify/domain/tasks/models/task_duration_type.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_when/bloc/select_task_when_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_period/select_task_period_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SelectTaskDateBottomSheet extends StatelessWidget {
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

  Future<void> _onDatePressed(
    BuildContext context,
    SelectTaskWhenBloc bloc,
    DateTime initialDate,
  ) async {
    final picked = await AppDateTimePicker.pickDate(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      bloc.add(SelectTaskWhenEvent.dateSelected(picked));
    }
  }

  Future<void> _onDurationPressed(
    BuildContext context,
    SelectTaskWhenBloc bloc,
    TaskDurationType selectedType,
  ) async {
    await showAppBottomSheet<void>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectTaskPeriodBottomSheet(
        selectedType: selectedType,
        onSelected: (type) =>
            bloc.add(SelectTaskWhenEvent.durationTypeSelected(type)),
      ),
    );
  }

  Future<void> _onStartTimePressed(
    BuildContext context,
    SelectTaskWhenBloc bloc,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('syncTag use24Hour: $use24Hour');
    final picked = await AppDateTimePicker.pickTime(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      use24hFormat: use24Hour,
      localeOverride: const Locale('en', 'US'),
    );
    if (picked != null) {
      bloc.add(SelectTaskWhenEvent.startTimeSelected(picked));
    }
  }

  Future<void> _onEndTimePressed(
    BuildContext context,
    SelectTaskWhenBloc bloc,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('syncTag use24Hour: $use24Hour');
    final picked = await AppDateTimePicker.pickTime(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      use24hFormat: use24Hour,
      localeOverride: const Locale('en', 'US'),
    );
    if (picked != null) {
      bloc.add(SelectTaskWhenEvent.endTimeSelected(picked));
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(date);
  }

  List<CardAction> _buildCardActions(
    BuildContext context,
    SelectTaskWhenState selectTaskState,
    SelectTaskWhenBloc selectTaskBloc,
    bool isPeriod,
    bool use24Hour,
  ) {
    final l10n = AppLocalizations.of(context);
    final current = selectTaskState.current;
    return [
      CardAction(
        title: l10n?.date ?? '',
        description: _formatDate(context, current.selectedDate),
        onPressed: () =>
            _onDatePressed(context, selectTaskBloc, current.selectedDate),
      ),
      CardAction(
        title: l10n?.period ?? '',
        description: current.durationType == TaskDurationType.allDay
            ? l10n?.allDay ?? ''
            : l10n?.period ?? '',
        onPressed: () =>
            _onDurationPressed(context, selectTaskBloc, current.durationType),
      ),
      if (isPeriod)
        CardAction(
          title: l10n?.startTime ?? '',
          description: formatTimeOfDay(context, current.startTime, use24Hour),
          onPressed: () => _onStartTimePressed(
            context,
            selectTaskBloc,
            current.startTime,
            use24Hour,
          ),
        ),
      if (isPeriod)
        CardAction(
          title: l10n?.endTime ?? '',
          description: formatTimeOfDay(context, current.endTime, use24Hour),
          onPressed: () => _onEndTimePressed(
            context,
            selectTaskBloc,
            current.endTime,
            use24Hour,
          ),
        ),
    ];
  }

  void _onSavePressed(
    BuildContext context,
    SelectTaskWhenState selectTaskState,
  ) {
    final current = selectTaskState.current;
    final startDateTime =
        current.durationType == TaskDurationType.period &&
            current.startTime != null
        ? DateTime(
            current.selectedDate.year,
            current.selectedDate.month,
            current.selectedDate.day,
            current.startTime!.hour,
            current.startTime!.minute,
          )
        : null;
    final endDateTime =
        current.durationType == TaskDurationType.period &&
            current.endTime != null
        ? DateTime(
            current.selectedDate.year,
            current.selectedDate.month,
            current.selectedDate.day,
            current.endTime!.hour,
            current.endTime!.minute,
          )
        : null;
    onSave?.call(
      current.selectedDate,
      current.durationType == TaskDurationType.allDay,
      startDateTime,
      endDateTime,
    );
    Navigator.of(context).pop();
  }

  void _onClearPressed(BuildContext context, SelectTaskWhenBloc bloc) {
    bloc.add(const SelectTaskWhenEvent.selectionCleared());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );

    return BlocBuilder<SelectTaskWhenBloc, SelectTaskWhenState>(
      builder: (context, selectTaskState) {
        final selectTaskBloc = context.read<SelectTaskWhenBloc>();
        final current = selectTaskState.current;
        final isModified = !current.isSameAs(selectTaskState.defaults);
        final isPeriod = current.durationType == TaskDurationType.period;

        return Padding(
          padding: AppInsets.sheetHorizontalSmallPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(12),
              Text(
                l10n?.when ?? '',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              CardWithActions(
                actions: _buildCardActions(
                  context,
                  selectTaskState,
                  selectTaskBloc,
                  isPeriod,
                  use24Hour,
                ),
                animatable: true,
              ),
              const Gap(48),
              if (isModified)
                GestureDetector(
                  onTap: () => _onClearPressed(context, selectTaskBloc),
                  child: Text(
                    l10n?.clearSelection ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColorExtensions.getPrimaryAccentColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (isModified) const Gap(12),
              Padding(
                padding: AppInsets.sheetBottomPadding,
                child: AppTextButton(
                  text: l10n?.save ?? '',
                  onPressed: () => _onSavePressed(context, selectTaskState),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
