import 'package:design/themes/color/app_color_extensions.dart';
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

  @override
  Widget build(BuildContext context) {
    final accentColor =
        AppColorExtensions.getPrimaryAccentColor(context).withValues(alpha: 96 / 255);
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox.expand(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
              )
            : ColoredBox(
                color: accentColor,
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
  }
}
