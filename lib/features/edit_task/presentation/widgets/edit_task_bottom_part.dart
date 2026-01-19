import 'package:design/widgets/app_bottom_sheet.dart';
import 'package:design/widgets/app_text_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_tags_part.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_time_button.dart';
import 'package:taskify/features/select_task_date/presentation/select_task_date_page.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskBottomPart extends StatelessWidget {
  const EditTaskBottomPart({
    super.key,
    required this.onSavePressed,
    required this.onDateSelected,
  });

  final VoidCallback onSavePressed;

  final void Function(
    DateTime selectedDate,
    bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  ) onDateSelected;

  Future<void> _onTimePressed(BuildContext context, EditTaskState state) async {
    await _dismissKeyboard(context);
    showFullScreenBottomSheet(
      context: context,
      useSafeArea: true,
      child: SelectTaskDatePage(
        selectedDate: state.selectedDate,
        isAllDay: state.isAllDay,
        startTime: state.startTime,
        endTime: state.endTime,
        onSave: onDateSelected,
      ),
    );
  }

  Future<void> _dismissKeyboard(BuildContext context) async {
    final focus = FocusManager.instance.primaryFocus;
    if (focus != null && focus.hasFocus) {
      focus.unfocus();
    }

    const step = Duration(milliseconds: 16);
    const maxWait = Duration(milliseconds: 300);
    final end = DateTime.now().add(maxWait);

    while (DateTime.now().isBefore(end)) {
      await Future.delayed(step);
      if (!context.mounted) return;
      if (MediaQuery.viewInsetsOf(context).bottom == 0) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EditTaskTagsPart(),
              Row(
                children: [
                  EditTaskTimeButton(
                    isEnabled: state.titleIsNotEmpty,
                    onPressed: () => _onTimePressed(context, state),
                  ),
                  const Gap(8),
                  Expanded(
                    child: AppTextButton(
                      text: AppLocalizations.of(context)?.save ?? '',
                      isEnabled: state.titleIsNotEmpty,
                      onPressed: onSavePressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
