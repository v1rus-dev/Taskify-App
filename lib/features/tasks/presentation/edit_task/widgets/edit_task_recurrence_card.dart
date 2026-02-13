import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/tasks/data/models/task_recurrence.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/task_recurrence/recurrence_type_bottom_sheet.dart';
import 'package:taskify/features/tasks/presentation/edit_task/bloc/edit_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskRecurrenceCard extends StatelessWidget {
  const EditTaskRecurrenceCard({super.key});

  String _recurrenceLabel(BuildContext context, TaskRecurrence? recurrence) {
    final l10n = AppLocalizations.of(context);
    if (recurrence == null) {
      return l10n?.doesNotRepeat ?? '';
    }
    return switch (recurrence.frequency) {
      TaskRecurrenceFrequency.daily => l10n?.recurrenceDaily ?? '',
      TaskRecurrenceFrequency.weekly => l10n?.recurrenceWeekly ?? '',
      TaskRecurrenceFrequency.monthly => l10n?.recurrenceMonthly ?? '',
      TaskRecurrenceFrequency.yearly => l10n?.recurrenceYearly ?? '',
    };
  }

  Future<void> _onRecurrencePressed(
    BuildContext context,
    TaskRecurrence? selectedRecurrence,
  ) {
    final editTaskBloc = context.read<EditTaskBloc>();
    return unfocusAndThen(
      context,
      () => showAppBottomSheet<void>(
        context: context,
        type: AppBottomSheetType.floating,
        child: RecurrenceTypeBottomSheet(
          selectedRecurrence: selectedRecurrence,
          onSelected: (value) {
            editTaskBloc.add(EditTaskRecurrenceChanged(value));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      buildWhen: (previous, current) =>
          previous.recurrence != current.recurrence,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        return CardWithActions(
          showAppShadow: false,
          actions: [
            CardActionEntry(
              CardAction(
                title: l10n?.recurrence ?? '',
                description: _recurrenceLabel(context, state.recurrence),
                onPressed: () =>
                    _onRecurrencePressed(context, state.recurrence),
              ),
            ),
          ],
          animatable: true,
        );
      },
    );
  }
}
