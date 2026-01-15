import 'package:design/widgets/app_bottom_sheet.dart';
import 'package:design/widgets/app_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_time_button.dart';
import 'package:taskify/features/select_task_date/presentation/select_task_date_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskBottomPart extends ConsumerWidget {
  const EditTaskBottomPart({
    super.key,
    required this.canSave,
    required this.onSavePressed,
    required this.selectedDate,
    required this.isAllDay,
    required this.startTime,
    required this.endTime,
    required this.onDateSelected,
  });

  final bool canSave;
  final VoidCallback onSavePressed;
  final DateTime selectedDate;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;
  final void Function(
    DateTime selectedDate,
    bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  )
  onDateSelected;

  void _onTimePressed(BuildContext context) {
    showAppModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      child: SelectTaskDateBottomSheet(
        selectedDate: selectedDate,
        isAllDay: isAllDay,
        startTime: startTime,
        endTime: endTime,
        onSave: onDateSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            EditTaskTimeButton(
              isEnabled: canSave,
              onPressed: () => _onTimePressed(context),
            ),
            const Gap(8),
            Expanded(
              child: AppTextButton(
                text: AppLocalizations.of(context)?.save ?? '',
                isEnabled: canSave,
                onPressed: onSavePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
