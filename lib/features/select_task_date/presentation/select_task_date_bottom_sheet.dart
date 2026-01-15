import 'package:design/widgets/app_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/select_task_date/presentation/providers/select_task/select_task_notifier.dart';
import 'package:taskify/features/select_task_date/presentation/widgets/calendar_part.dart';

class SelectTaskDateBottomSheet extends ConsumerWidget {
  const SelectTaskDateBottomSheet({
    super.key,
    this.selectedDate,
    this.isAllDay,
    this.onSave,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;
  final void Function(DateTime selectedDate, bool isAllDay)? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectTaskState = ref.watch(
      selectTaskNotifierProvider((selectedDate, isAllDay)),
    );
    final selectTaskNotifier = ref.read(
      selectTaskNotifierProvider((selectedDate, isAllDay)).notifier,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("When", style: theme.textTheme.displayMedium),
                const SizedBox(height: 20),
                CalendarPart(
                  selectedDate: selectedDate,
                  isAllDay: isAllDay,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('All day'),
                      selected: selectTaskState.isAllDay,
                      onSelected: (_) => selectTaskNotifier.onSelectAllDay(),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('With time'),
                      selected: !selectTaskState.isAllDay,
                      onSelected: (_) => selectTaskNotifier.onSelectDuration(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: AppTextButton(
            text: "Save",
            onPressed: () {
              onSave?.call(
                selectTaskState.selectedDate,
                selectTaskState.isAllDay,
              );
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
