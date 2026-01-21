import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design/design.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/create_user_tag/bloc/create_user_tag_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/create_user_tag/widgets/color_list.dart';
import 'package:taskify/domain/entities/default_tag_color.dart';

class CreateUserTagBottomSheet extends StatefulWidget {
  const CreateUserTagBottomSheet({super.key});

  @override
  State<CreateUserTagBottomSheet> createState() =>
      _CreateUserTagBottomSheetState();
}

class _CreateUserTagBottomSheetState extends State<CreateUserTagBottomSheet> {
  Color _selectedColor = DefaultTagColor.values[0].color;

  void _onCreateTagPressed() {
    // context.read<CreateUserTagBloc>().add(CreateUserTagEvent.created(name: name, color: _selectedColor));
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CreateUserTagBloc, CreateUserTagState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: AppInsets.sheetHorizontalSmallPadding,
                child: Column(
                  children: [
                    const Gap(12),
                    Text(
                      'Create tag',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(24),
                    // Add Text field
                    const Gap(24),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: AppInsets.sheetHorizontalSmallPadding,
                  child: Text(
                    'Color',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const Gap(16),
              ColorList(
                selectedColor: _selectedColor,
                onColorSelected: _onColorSelected,
              ),
              const Gap(48),
              Text(
                'Create a custom tag for your tasks',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
              ),
              const Gap(12),
              Padding(
                padding: AppInsets.sheetBottomPadding,
                child: AppTextButton(
                  text: 'Create tag',
                  onPressed: _onCreateTagPressed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
