import 'package:flutter/material.dart';

@immutable
class AppColorSchemeExtension extends ThemeExtension<AppColorSchemeExtension> {
  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color primaryAccent;
  final Color buttonPrimaryBackground;
  final Color buttonPrimaryText;
  final Color buttonDisabledBackground;
  final Color buttonDisabledText;
  final Color shadow;
  final Color bottomSheetOverlay;
  final Color error;
  final Color success;
  final Color pending;

  const AppColorSchemeExtension({
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.primaryAccent,
    required this.buttonPrimaryBackground,
    required this.buttonPrimaryText,
    required this.buttonDisabledBackground,
    required this.buttonDisabledText,
    required this.shadow,
    required this.bottomSheetOverlay,
    required this.error,
    required this.success,
    required this.pending,
  });

  @override
  AppColorSchemeExtension copyWith({
    Color? background,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? primaryAccent,
    Color? buttonPrimaryBackground,
    Color? buttonPrimaryText,
    Color? buttonDisabledBackground,
    Color? buttonDisabledText,
    Color? shadow,
    Color? bottomSheetOverlay,
    Color? error,
    Color? success,
    Color? pending,
  }) {
    return AppColorSchemeExtension(
      background: background ?? this.background,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      buttonPrimaryBackground: buttonPrimaryBackground ?? this.buttonPrimaryBackground,
      buttonPrimaryText: buttonPrimaryText ?? this.buttonPrimaryText,
      buttonDisabledBackground: buttonDisabledBackground ?? this.buttonDisabledBackground,
      buttonDisabledText: buttonDisabledText ?? this.buttonDisabledText,
      shadow: shadow ?? this.shadow,
      bottomSheetOverlay: bottomSheetOverlay ?? this.bottomSheetOverlay,
      error: error ?? this.error,
      success: success ?? this.success,
      pending: pending ?? this.pending,
    );
  }

  @override
  AppColorSchemeExtension lerp(ThemeExtension<AppColorSchemeExtension>? other, double t) {
    if (other is! AppColorSchemeExtension) return this;
    return AppColorSchemeExtension(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      buttonPrimaryBackground: Color.lerp(buttonPrimaryBackground, other.buttonPrimaryBackground, t)!,
      buttonPrimaryText: Color.lerp(buttonPrimaryText, other.buttonPrimaryText, t)!,
      buttonDisabledBackground: Color.lerp(buttonDisabledBackground, other.buttonDisabledBackground, t)!,
      buttonDisabledText: Color.lerp(buttonDisabledText, other.buttonDisabledText, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      bottomSheetOverlay: Color.lerp(bottomSheetOverlay, other.bottomSheetOverlay, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
    );
  }
}
