import 'package:design/design.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_tags_part.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_time_button.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_task_when/select_task_when_page.dart';

class EditTaskBottomPart extends StatelessWidget {
  const EditTaskBottomPart({
    super.key,
  });

  void _onTimePressed(BuildContext context) {
    final editTaskBloc = context.read<EditTaskBloc>();
    unfocusAndThen(
      context,
      () => showAppBottomSheet<void>(
        context: context,
        useSafeArea: true,
        type: AppBottomSheetType.floating,
        child: BlocProvider.value(
          value: editTaskBloc,
          child: const SelectTaskWhenPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EditTaskTagsPart(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  EditTaskTimeButton(
                    isEnabled: state.titleIsNotEmpty,
                    showIndicator: state.isDateModified,
                    onPressed: () => _onTimePressed(context),
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
        );
      },
    );
  }
}
