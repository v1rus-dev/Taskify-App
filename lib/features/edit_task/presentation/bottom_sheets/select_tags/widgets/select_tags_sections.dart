import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_tags/widgets/tag_button.dart';
import 'package:taskify/l10n/app_localizations.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({
    super.key,
    required this.title,
    required this.tags,
    required this.selectedTagKeys,
    required this.onTagPressed,
  });

  final String title;
  final List<TagEntity> tags;
  final Set<String> selectedTagKeys;
  final ValueChanged<TagEntity> onTagPressed;

  void _onTagChipPressed(TagEntity tag) {
    onTagPressed(tag);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (tag) => TagButton(
                  tag: tag,
                  isSelected: selectedTagKeys.contains(tag.key),
                  onPressed: () => _onTagChipPressed(tag),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class CustomTagsSection extends StatelessWidget {
  const CustomTagsSection({
    super.key,
    required this.tags,
    required this.selectedTagKeys,
    required this.onTagPressed,
    required this.onCreatePressed,
  });

  final List<TagEntity> tags;
  final Set<String> selectedTagKeys;
  final ValueChanged<TagEntity> onTagPressed;
  final VoidCallback onCreatePressed;

  void _onTagChipPressed(TagEntity tag) {
    onTagPressed(tag);
  }

  void _onCreatePressed() {
    onCreatePressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n?.customs ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            CreateTagButton(onPressed: _onCreatePressed),
          ],
        ),
        const Gap(12),
        if (tags.isEmpty)
          Text(
            l10n?.noCustomTags ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColorExtensions.getTextSecondaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => TagButton(
                    tag: tag,
                    isSelected: selectedTagKeys.contains(tag.key),
                    onPressed: () => _onTagChipPressed(tag),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}

class CreateTagButton extends StatelessWidget {
  const CreateTagButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  void _onPressed() {
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColorExtensions.getPrimaryAccentColor(context);
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: _onPressed,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            l10n?.createTag ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
