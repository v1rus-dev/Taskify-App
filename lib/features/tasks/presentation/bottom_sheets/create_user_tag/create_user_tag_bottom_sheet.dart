import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design/design.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/create_user_tag/bloc/create_user_tag_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/create_user_tag/widgets/color_list.dart';
import 'package:taskify/domain/tags/models/default_tag_color.dart';
import 'package:taskify/l10n/app_localizations.dart';

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
      const CreateUserTagCreatePressed(),
    );
  }

  void _onColorSelected(Color color) {
    context.read<CreateUserTagBloc>().add(
      CreateUserTagColorChanged(color),
    );
  }

  void _onNameChanged(String value) {
    context.read<CreateUserTagBloc>().add(
      CreateUserTagNameChanged(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<CreateUserTagBloc, CreateUserTagState>(
      listener: (context, state) {
        if (state is CreateUserTagSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        Color selectedColor = DefaultTagColor.values.first.color;
        bool isEnabled = false;
        if (state is CreateUserTagEditing) {
          selectedColor = state.color;
          isEnabled = state.isValid;
        } else if (state is CreateUserTagSaving) {
          selectedColor = state.color;
        } else if (state is CreateUserTagError) {
          selectedColor = state.color;
          isEnabled = state.isValid;
        }
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
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
                          l10n?.createTag ?? '',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        AppEditText(
                          hint: l10n?.tagName ?? '',
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
                        l10n?.color ?? '',
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
                    l10n?.createCustomTagHint ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColorExtensions.getTextSecondaryColor(context),
                    ),
                  ),
                  const Gap(8),
                  Padding(
                    padding: AppInsets.sheetBottomPadding,
                    child: AppTextButton(
                      text: l10n?.createTag ?? '',
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
