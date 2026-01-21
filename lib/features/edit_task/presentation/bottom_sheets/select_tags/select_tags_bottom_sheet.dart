import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/entities/tag.dart';
import 'bloc/select_tags_bloc.dart';
import 'widgets/select_tags_sections.dart';

class SelectTagsBottomSheet extends StatelessWidget {
  const SelectTagsBottomSheet({super.key});

  void _onTagPressed(BuildContext context, TagEntity tag) {
    context.read<SelectTagsBloc>().add(SelectTagsEvent.tagToggled(tag));
  }

  void _onCreateTagPressed(BuildContext context) {
    context.read<SelectTagsBloc>().add(const SelectTagsEvent.createTagPressed());
  }

  void _onSavePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildContent(BuildContext context, SelectTagsState state) {
    final theme = Theme.of(context);
    return state.maybeWhen(
      success: (defaultTags, customTags, selectedTagIds) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagsSection(
              title: 'Defaults',
              tags: defaultTags,
              selectedTagIds: selectedTagIds,
              onTagPressed: (tag) => _onTagPressed(context, tag),
            ),
            const Gap(24),
            CustomTagsSection(
              tags: customTags,
              selectedTagIds: selectedTagIds,
              onTagPressed: (tag) => _onTagPressed(context, tag),
              onCreatePressed: () => _onCreateTagPressed(context),
            ),
            const Gap(24),
            Center(
              child: Text(
                'Tags help you organize and filter your tasks',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(12),
            Padding(
              padding: AppInsets.sheetBottomPadding,
              child: AppTextButton(
                text: "Save",
                onPressed: () => _onSavePressed(context),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

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
                _buildContent(context, state),
              ],
            ),
          ),
        );
      },
    );
  }
}
