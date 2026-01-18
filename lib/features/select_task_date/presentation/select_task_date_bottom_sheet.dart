import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/time_format_utils.dart';
import 'package:taskify/domain/entities/task_duration_type.dart';
import 'package:taskify/features/select_task_date/presentation/bloc/select_task_date_bloc.dart';
import 'package:taskify/features/select_task_date/presentation/select_task_period_bottom_sheet.dart';

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
    SelectTaskDateBloc bloc,
    DateTime initialDate,
  ) async {
    final picked = await AppDateTimePicker.pickDate(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      bloc.add(SelectTaskDateEvent.dateSelected(picked));
    }
  }

  Future<void> _onDurationPressed(
    BuildContext context,
    SelectTaskDateBloc bloc,
    TaskDurationType selectedType,
  ) async {
    await showAppModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      child: SelectTaskPeriodBottomSheet(
        selectedType: selectedType,
        onSelected: (type) =>
            bloc.add(SelectTaskDateEvent.durationTypeSelected(type)),
      ),
    );
  }

  Future<void> _onStartTimePressed(
    BuildContext context,
    SelectTaskDateBloc bloc,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('use24Hour: $use24Hour');
    final picked = await AppDateTimePicker.pickTime(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      use24hFormat: use24Hour,
      localeOverride: const Locale('en', 'US'),
    );
    if (picked != null) {
      bloc.add(SelectTaskDateEvent.startTimeSelected(picked));
    }
  }

  Future<void> _onEndTimePressed(
    BuildContext context,
    SelectTaskDateBloc bloc,
    TimeOfDay? initialTime,
    bool use24Hour,
  ) async {
    TalkerService.instance.info('use24Hour: $use24Hour');
    final picked = await AppDateTimePicker.pickTime(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      use24hFormat: use24Hour,
      localeOverride: const Locale('en', 'US'),
    );
    if (picked != null) {
      bloc.add(SelectTaskDateEvent.endTimeSelected(picked));
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(date);
  }

  List<CardAction> _buildCardActions(
    BuildContext context,
    SelectTaskDateState selectTaskState,
    SelectTaskDateBloc selectTaskBloc,
    bool isPeriod,
    bool use24Hour,
  ) {
    return [
      CardAction(
        title: 'Date',
        description: _formatDate(context, selectTaskState.selectedDate),
        onPressed: () => _onDatePressed(
          context,
          selectTaskBloc,
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
          selectTaskBloc,
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
            selectTaskBloc,
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
            selectTaskBloc,
            selectTaskState.endTime,
            use24Hour,
          ),
        ),
    ];
  }

  void _onSavePressed(
    BuildContext context,
    SelectTaskDateState selectTaskState,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );

    return BlocBuilder<SelectTaskDateBloc, SelectTaskDateState>(
      builder: (context, selectTaskState) {
        final selectTaskBloc = context.read<SelectTaskDateBloc>();
        final isPeriod = selectTaskState.durationType == TaskDurationType.period;

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
                        selectTaskBloc,
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
                onPressed: () => _onSavePressed(context, selectTaskState),
              ),
            ),
          ],
        );
      },
    );
  }
}
