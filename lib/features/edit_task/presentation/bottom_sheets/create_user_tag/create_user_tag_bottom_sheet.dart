import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design/design.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/create_user_tag/bloc/create_user_tag_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/edit_task/presentation/bottom_sheets/create_user_tag/widgets/color_list.dart';
import 'package:taskify/domain/tags/models/default_tag_color.dart';

class CreateUserTagBottomSheet extends StatefulWidget {
  const CreateUserTagBottomSheet({super.key});

  @override
  State<CreateUserTagBottomSheet> createState() =>
      _CreateUserTagBottomSheetState();
}

class _CreateUserTagBottomSheetState extends State<CreateUserTagBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  late final VoidCallback _nameListener;

  @override
  void initState() {
    super.initState();
    _nameListener = () => _onNameChanged(_nameController.text);
    _nameController.addListener(_nameListener);
  }

  @override
  void dispose() {
    _nameController.removeListener(_nameListener);
    _nameController.dispose();
    super.dispose();
  }

  void _onCreateTagPressed() {
    context.read<CreateUserTagBloc>().add(
      const CreateUserTagEvent.createPressed(),
    );
  }

  void _onColorSelected(Color color) {
    context.read<CreateUserTagBloc>().add(
      CreateUserTagEvent.colorChanged(color),
    );
  }

  void _onNameChanged(String value) {
    context.read<CreateUserTagBloc>().add(
      CreateUserTagEvent.nameChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<CreateUserTagBloc, CreateUserTagState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (_) => Navigator.of(context).pop(),
        );
      },
      builder: (context, state) {
        final selectedColor = state.maybeMap(
          editing: (state) => state.color,
          saving: (state) => state.color,
          error: (state) => state.color,
          orElse: () => DefaultTagColor.values.first.color,
        );
        final isEnabled = state.maybeMap(
          editing: (state) => state.isValid,
          error: (state) => state.isValid,
          orElse: () => false,
        );
        return MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
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
                        const Gap(16),
                        AppEditText(
                          hint: 'Tag name',
                          controller: _nameController,
                          trailing: null,
                        ),
                        const Gap(16),
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
                    selectedColor: selectedColor,
                    onColorSelected: _onColorSelected,
                  ),
                  const Gap(24),
                  Text(
                    'Create a custom tag for your tasks',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColorExtensions.getTextSecondaryColor(context),
                    ),
                  ),
                  const Gap(8),
                  Padding(
                    padding: AppInsets.sheetBottomPadding,
                    child: AppTextButton(
                      text: 'Create tag',
                      isEnabled: isEnabled,
                      onPressed: _onCreateTagPressed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
