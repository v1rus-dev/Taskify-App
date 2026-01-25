import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'bloc/select_tags_bloc.dart';
import 'widgets/select_tags_sections.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/create_user_tag/create_user_tag_page.dart';

class SelectTagsBottomSheet extends StatelessWidget {
  const SelectTagsBottomSheet({super.key});

  void _onTagPressed(BuildContext context, TagEntity tag) {
    context.read<SelectTagsBloc>().add(SelectTagsEvent.tagToggled(tag));
  }

  void _onCreateTagPressed(BuildContext context) {
    showAppBottomSheet(
      context: context,
      type: AppBottomSheetType.standard,
      child: BlocProvider.value(
        value: context.read<EditTaskBloc>(),
        child: const CreateUserTagPage(),
      ),
    );
  }

  void _onSavePressed(BuildContext context) {
    final selectedTags = _collectSelectedTags(context);
    context.read<EditTaskBloc>().add(EditTaskEvent.tagsUpdated(selectedTags));
    Navigator.of(context).pop();
  }

  List<TagEntity> _collectSelectedTags(BuildContext context) {
    final state = context.read<SelectTagsBloc>().state;
    return state.maybeWhen(
      success: (defaultTags, customTags, selectedTagKeys) {
        final allTags = [...defaultTags, ...customTags];
        return allTags
            .where((tag) => selectedTagKeys.contains(tag.key))
            .toList(growable: false);
      },
      orElse: () => const <TagEntity>[],
    );
  }

  Widget _buildContent(BuildContext context, SelectTagsState state) {
    final theme = Theme.of(context);

    return state.maybeWhen(
      success: (defaultTags, customTags, selectedTagKeys) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagsSection(
                      title: 'Defaults',
                      tags: defaultTags,
                      selectedTagKeys: selectedTagKeys,
                      onTagPressed: (tag) => _onTagPressed(context, tag),
                    ),
                    const Gap(24),
                    CustomTagsSection(
                      tags: customTags,
                      selectedTagKeys: selectedTagKeys,
                      onTagPressed: (tag) => _onTagPressed(context, tag),
                      onCreatePressed: () => _onCreateTagPressed(context),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(12),
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
            AppTextButton(
              text: "Save",
              onPressed: () => _onSavePressed(context),
            ),
            const Gap(AppInsets.sheetBottomSmall),
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
          child: Column(
            children: [
              const Gap(12),
              Text(
                "Select tags",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }
}
