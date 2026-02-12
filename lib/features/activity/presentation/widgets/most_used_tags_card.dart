import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:taskify/core/widgets/tag_cheap.dart';
import 'package:taskify/l10n/app_localizations.dart';

class MostUsedTagsCard extends StatelessWidget {
  const MostUsedTagsCard({super.key, required this.tagsInfo});

  final TagsInfo tagsInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final topTags = tagsInfo.topTags.take(3).toList();
    final isEmpty = topTags.isEmpty;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n?.mostUsedTags ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColorExtensions.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n?.emptyTags ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topTags
                  .map(
                    (t) => TagCheap(
                      tag: CustomTagEntity(
                        id: t.tagId,
                        title: t.title,
                        color: Color(t.colorValue),
                      ),
                      onPressed: () {},
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

