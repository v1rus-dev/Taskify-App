import 'package:design/design.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'bloc/select_tags_bloc.dart';

class SelectTagsBottomSheet extends StatelessWidget {
  const SelectTagsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SelectTagsBloc, SelectTagsState>(
      builder: (context, state) {
        return Padding(
          padding: AppInsets.sheetHorizontalSmallPadding,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(12),
                Text(
                  "Select tags",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
