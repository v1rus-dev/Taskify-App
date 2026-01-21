import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/select_tags_bloc.dart';
import 'select_tags_bottom_sheet.dart';

class SelectTagsPage extends StatelessWidget {
  const SelectTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectTagsBloc()..add(const SelectTagsEvent.started()),
      child: const SelectTagsBottomSheet(),
    );
  }
}
