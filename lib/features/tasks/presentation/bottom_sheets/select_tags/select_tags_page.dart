import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/tasks/presentation/edit_task/bloc/edit_task_bloc.dart';
import 'bloc/select_tags_bloc.dart';
import 'select_tags_bottom_sheet.dart';

class SelectTagsPage extends StatelessWidget {
  const SelectTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTagKeys = context
        .read<EditTaskBloc>()
        .state
        .selectedTags
        .map((tag) => tag.key)
        .toSet();
    return BlocProvider(
      create: (_) => SelectTagsBloc(
        initialSelectedTagKeys: selectedTagKeys,
      )..add(const SelectTagsStarted()),
      child: const SelectTagsBottomSheet(),
    );
  }
}
