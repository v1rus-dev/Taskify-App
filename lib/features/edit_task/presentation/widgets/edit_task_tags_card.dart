import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/core/widgets/tag_cheap.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:design/design.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/select_tags/select_tags_page.dart';

class EditTaskTagsCard extends StatelessWidget {
  const EditTaskTagsCard({super.key});

  void _onAddTagsPressed(BuildContext context) {
    final editTaskBloc = context.read<EditTaskBloc>();
    unfocusAndThen(
      context,
      () => showAppBottomSheet(
        context: context,
        type: AppBottomSheetType.fullScreen,
        child: BlocProvider.value(
          value: editTaskBloc,
          child: const SelectTagsPage(),
        ),
      ),
    );
  }

  void _onTagPressed(BuildContext context, TagEntity tag) {
    final editTaskBloc = context.read<EditTaskBloc>();
    editTaskBloc.add(EditTaskRemoveTag(tag));
  }

  BorderRadius _borderRadiusByHasTags(bool hasTags) {
    if (hasTags) {
      return BorderRadius.vertical(
        bottom: Radius.circular(AppRadius.defaultCardRadius),
      );
    } else {
      return BorderRadius.circular(AppRadius.defaultCardRadius);
    }
  }

  Widget addTagsButton(BuildContext context, bool hasTags) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: _borderRadiusByHasTags(hasTags),
      child: InkWell(
        onTap: () => _onAddTagsPressed(context),
        borderRadius: _borderRadiusByHasTags(hasTags),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(context)?.addTags ?? '',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColorExtensions.getTextSecondaryColor(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(
                AppIcons.addSmall,
                package: AppIcons.packageName,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Color(0xFFE6E6E6),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.defaultCard,
            color: AppColorExtensions.getCardColor(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.selectedTags.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...state.selectedTags.map(
                        (tag) => TagCheap(tag: tag, onPressed: () => _onTagPressed(context, tag)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: AppColorExtensions.getDividerColor(context),
                    height: 1,
                  ),
                ),
              ],
              addTagsButton(context, state.selectedTags.isNotEmpty),
            ],
          ),
        );
      },
    );
  }
}
