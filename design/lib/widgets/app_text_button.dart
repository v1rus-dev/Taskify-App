import 'package:design/design.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    this.isEnabled = true,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  Color _getBackgroundColor() =>
      isEnabled ? Color(0xFF002FFF).withValues(alpha: 0.6) : Color(0xFFDEDEDE);
  Color _getTextColor() => isEnabled ? Colors.white : Color(0xFF898989);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 60,
        maxHeight: 60,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 60,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: AppTypography.bodyLarge.copyWith(color: _getTextColor()),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
