import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/tasks/data/models/task_reminder.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/task_reminder/reminder_bottom_sheet.dart';
import 'package:taskify/features/tasks/presentation/edit_task/bloc/edit_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskReminderCard extends StatelessWidget {
  const EditTaskReminderCard({super.key});

  String _reminderLabel(BuildContext context, TaskReminder? reminder) {
    final l10n = AppLocalizations.of(context);
    if (reminder == null) {
      return l10n?.noReminder ?? '';
    }

    return switch (reminder.type) {
      TaskReminderType.atTime => l10n?.reminderAtTime ?? '',
      TaskReminderType.fiveMinutesBefore =>
        l10n?.reminderFiveMinutesBefore ?? '',
      TaskReminderType.tenMinutesBefore => l10n?.reminderTenMinutesBefore ?? '',
      TaskReminderType.fifteenMinutesBefore =>
        l10n?.reminderFifteenMinutesBefore ?? '',
      TaskReminderType.thirtyMinutesBefore =>
        l10n?.reminderThirtyMinutesBefore ?? '',
      TaskReminderType.oneHourBefore => l10n?.reminderOneHourBefore ?? '',
      TaskReminderType.oneDayBefore => l10n?.reminderOneDayBefore ?? '',
    };
  }

  Future<void> _onReminderPressed(
    BuildContext context,
    TaskReminder? selectedReminder,
  ) {
    final editTaskBloc = context.read<EditTaskBloc>();
    return unfocusAndThen(
      context,
      () => showAppBottomSheet<void>(
        context: context,
        type: AppBottomSheetType.floating,
        child: ReminderBottomSheet(
          selectedReminder: selectedReminder,
          onSelected: (value) {
            editTaskBloc.add(EditTaskReminderChanged(value));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      buildWhen: (previous, current) => previous.reminder != current.reminder,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        return CardWithActions(
          showAppShadow: false,
          actions: [
            CardActionEntry(
              CardAction(
                title: l10n?.reminder ?? '',
                description: _reminderLabel(context, state.reminder),
                onPressed: () => _onReminderPressed(context, state.reminder),
              ),
            ),
          ],
          animatable: true,
        );
      },
    );
  }
}
