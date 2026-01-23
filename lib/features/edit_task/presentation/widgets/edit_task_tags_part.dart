import 'package:animated_visibility/animated_visibility.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/widgets/tag_cheap.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_tags/select_tags_page.dart';
import 'package:taskify/features/edit_task/presentation/widgets/add_tag_button.dart';
import 'package:gap/gap.dart';

class EditTaskTagsPart extends StatelessWidget {
  const EditTaskTagsPart({super.key});

  void _onAddTagPressed(BuildContext context) {
    final editTaskBloc = context.read<EditTaskBloc>();
    unfocusAndThen(
      context,
      () => showFloatingBottomSheet<void>(
        context: context,
        useSafeArea: true,
        handleKeyboardInsets: false,
        child: BlocProvider.value(
          value: editTaskBloc,
          child: const SelectTagsPage(),
        ),
      ),
    );
  }

  void _onTagPressed(BuildContext context, TagEntity tag) {
    final editTaskBloc = context.read<EditTaskBloc>();
    editTaskBloc.add(EditTaskEvent.removeTag(tag));
  }

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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    if (index == state.selectedTags.length) {
                      return AddTagButton(
                        onPressed: () => _onAddTagPressed(context),
                      );
                    }
                    return TagCheap(
                      tag: state.selectedTags[index],
                      onPressed: () =>
                          _onTagPressed(context, state.selectedTags[index]),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: state.selectedTags.length + 1,
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
