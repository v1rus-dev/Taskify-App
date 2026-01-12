import 'package:design/widgets/app_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_notifier.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_time_button.dart';

class EditTaskBottomPart extends ConsumerWidget {
  EditTaskBottomPart({super.key, required this.canSave});

  final bool canSave;

  _onTimePressed() {}

  _onSavePressed() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editTaskNotifierProvider);
    final notifier = ref.read(editTaskNotifierProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          EditTaskTimeButton(isEnabled: canSave, onPressed: _onTimePressed),
          const Gap(8),
          Expanded(
            child: AppTextButton(
              text: 'Save',
              isEnabled: canSave,
              onPressed: _onSavePressed,
            ),
          ),
        ],
      ),
    );
  }
}
