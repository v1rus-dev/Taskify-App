import 'package:flutter/material.dart';
import 'color/app_color_scheme.dart';
import 'typography/app_typography_extensions.dart';
import 'theme_extensions.dart';

ThemeData themeFromScheme(AppColorScheme scheme) {
  final colorSchemeExtension = AppColorSchemeExtension(
    background: scheme.background,
    card: scheme.card,
    textPrimary: scheme.textPrimary,
    textSecondary: scheme.textSecondary,
    divider: scheme.divider,
    primaryAccent: scheme.primaryAccent,
    buttonPrimaryBackground: scheme.buttonPrimaryBackground,
    buttonPrimaryText: scheme.buttonPrimaryText,
    buttonDisabledBackground: scheme.buttonDisabledBackground,
    buttonDisabledText: scheme.buttonDisabledText,
    shadow: scheme.shadow,
    bottomSheetOverlay: scheme.bottomSheetOverlay,
    error: scheme.error,
    success: scheme.success,
    pending: scheme.pending,
  );

  final typographyExtension = AppTypographyExtension(colorSchemeExtension);

  return ThemeData(
    scaffoldBackgroundColor: scheme.background,
    cardColor: scheme.card,
    dividerColor: scheme.divider,
    primaryColor: scheme.primaryAccent,
    textTheme: typographyExtension.textTheme,
    textSelectionTheme: typographyExtension.textSelectionTheme,
    extensions: [
      colorSchemeExtension,
      typographyExtension,
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.buttonDisabledBackground;
          }
          return scheme.buttonPrimaryBackground;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.buttonDisabledText;
          }
          return scheme.buttonPrimaryText;
        }),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.card,
      shadowColor: scheme.shadow,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
