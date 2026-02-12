import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/domain/models/default_tag_color.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/create_user_tag/widgets/color_card.dart';
import 'package:design/design.dart';

class ColorList extends StatelessWidget {
  const ColorList({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppInsets.sheetHorizontalSmallPadding,
        itemBuilder: (context, index) {
          return ColorCard(
            color: DefaultTagColor.values[index].color,
            isSelected: selectedColor == DefaultTagColor.values[index].color,
            onTap: onColorSelected,
          );
        },
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: DefaultTagColor.values.length,
      ),
    );
  }
}

