import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'bloc/select_tags_bloc.dart';
import 'select_tags_bottom_sheet.dart';

class SelectTagsPage extends StatelessWidget {
  const SelectTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTagIds = context
        .read<EditTaskBloc>()
        .state
        .selectedTags
        .map((tag) => tag.id)
        .toSet();
    return BlocProvider(
      create: (_) => SelectTagsBloc(
        initialSelectedTagIds: selectedTagIds,
      )..add(const SelectTagsEvent.started()),
      child: const SelectTagsBottomSheet(),
    );
  }
}
