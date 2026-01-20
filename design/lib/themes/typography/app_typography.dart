import 'package:design/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyInterDisplay = 'InterDisplay';

  static TextStyle headlineLarge(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInterDisplay,
      fontSize: 36,
      height: 43.2 / 36,
      color: scheme.textPrimary,
    );
  }

  static TextStyle headlineMedium(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInterDisplay,
      fontSize: 32,
      height: 38.4 / 32,
      color: scheme.textPrimary,
    );
  }

  static TextStyle titleLarge(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 24,
      height: 32 / 24,
      color: scheme.textPrimary,
    );
  }

  static TextStyle titleMedium(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 20,
      height: 28 / 20,
      color: scheme.textPrimary,
    );
  }

  static TextStyle titleSmall(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 18,
      height: 25.2 / 18,
      color: scheme.textPrimary,
    );
  }

  static TextStyle bodyLarge(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 16,
      height: 24 / 16,
      color: scheme.textPrimary,
    );
  }
  
  static TextStyle bodyMedium(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 14,
      height: 20 / 14,
      color: scheme.textPrimary,
    );
  }
  
  static TextStyle bodySmall(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 12,
      height: 16 / 12,
      color: scheme.textPrimary,
    );
  }
  
  static TextStyle labelLarge(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 16,
      height: 24 / 16,
      color: scheme.textPrimary,
    );
  }

  static TextStyle labelMedium(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 14,
      height: 20 / 14,
      color: scheme.textPrimary,
    );
  }
  
  static TextStyle labelSmall(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 12,
      height: 16 / 12,
      color: scheme.textPrimary,
    );
  }
}
