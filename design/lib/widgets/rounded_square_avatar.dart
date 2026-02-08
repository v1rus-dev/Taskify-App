import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundedSquareAvatar extends StatelessWidget {
  const RoundedSquareAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.borderRadius = 8,
    this.fallbackSize = 40,
  });

  final String? imageUrl;
  final String name;
  final double borderRadius;
  final double fallbackSize;

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
          final hasBoundedWidth = constraints.hasBoundedWidth;
          final hasBoundedHeight = constraints.hasBoundedHeight;
          final width = hasBoundedWidth
              ? constraints.maxWidth
              : (hasBoundedHeight ? constraints.maxHeight : fallbackSize);
          final height = hasBoundedHeight
              ? constraints.maxHeight
              : (hasBoundedWidth ? constraints.maxWidth : fallbackSize);
          final resolvedWidth = math.max(width, 0).toDouble();
          final resolvedHeight = math.max(height, 0).toDouble();

          return SizedBox(
            width: resolvedWidth,
            height: resolvedHeight,
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
