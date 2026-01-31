import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskDescriptionCard extends StatelessWidget {
  const EditTaskDescriptionCard({
    super.key,
    required this.descriptionController,
    required this.onChanged,
  });

  final TextEditingController descriptionController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          decoration: BoxDecoration(
            color: AppColorExtensions.getCardColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              TextField(
                controller: descriptionController,
                maxLines: null,
                maxLength: 265,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.description ?? '',
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColorExtensions.getTextSecondaryColor(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: descriptionController,
                    builder: (context, value, child) => Text(
                      '${value.text.length}/265',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColorExtensions.getTextSecondaryColor(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
