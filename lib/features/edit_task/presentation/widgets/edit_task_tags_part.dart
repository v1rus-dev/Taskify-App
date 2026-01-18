import 'package:animated_visibility/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/widgets/add_tag_button.dart';
import 'package:gap/gap.dart';

class EditTaskTagsPart extends StatelessWidget {
  const EditTaskTagsPart({super.key});

  void _onAddTagPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return AnimatedVisibility(
          visible: state.titleIsNotEmpty,
          enter:
              slideInVertically(curve: Curves.easeInOut) +
              fadeIn(curve: Curves.easeInOut),
          exit:
              slideOutVertically(curve: Curves.easeOut) +
              fadeOut(curve: Curves.easeOut),
          enterDuration: const Duration(milliseconds: 120),
          exitDuration: const Duration(milliseconds: 120),
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AddTagButton(
                      onPressed: () => _onAddTagPressed(context),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: 1,
                ),
              ),
              const Gap(16),
            ],
          ),
        );
      },
    );
  }
}
