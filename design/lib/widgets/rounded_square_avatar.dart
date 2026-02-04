import 'package:design/design.dart';
import 'package:flutter/material.dart';

class RoundedSquareAvatar extends StatelessWidget {
  const RoundedSquareAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.borderRadius = 8,
  });

  final String? imageUrl;
  final String name;
  final double borderRadius;

  Color _colorFromName() {
    final normalizedName = name.trim().toLowerCase();
    if (normalizedName.isEmpty) return AvatarColor.azure.color;
    final firstChar = normalizedName.characters.first;
    final index = firstChar.codeUnitAt(0) % AvatarColor.values.length;
    return AvatarColor.values[index].color;
  }

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final backgroundColor = _colorFromName();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return SizedBox(
            width: size.width,
            height: size.height,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: imageUrl != null && imageUrl!.trim().isNotEmpty
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : ColoredBox(
                      color: backgroundColor,
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
