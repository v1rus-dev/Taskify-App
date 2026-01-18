import 'package:design/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyInterDisplay = 'InterDisplay';

  static TextStyle header(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInterDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 43.2 / 36,
      color: scheme.textPrimary,
    );
  }

  static TextStyle title(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 22.4 / 16,
      color: scheme.textPrimary,
    );
  }

  static TextStyle body(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      color: scheme.textPrimary,
    );
  }

  static TextStyle bodyLarge(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 30 / 20,
      color: scheme.textPrimary,
    );
  }

  static TextStyle screenTitle(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 28.8 / 24,
      color: scheme.textPrimary,
    );
  }

  static TextStyle button(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 19.6 / 14,
      color: scheme.buttonPrimaryText,
    );
  }

  static TextStyle buttonBold(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 19.6 / 14,
      color: scheme.buttonPrimaryText,
    );
  }

  static TextStyle caption(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
      color: scheme.textSecondary,
    );
  }

  static TextStyle tag(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInter,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 14.4 / 12,
      color: scheme.textSecondary,
    );
  }

  static TextStyle editingHeader(AppColorSchemeExtension scheme) {
    return TextStyle(
      fontFamily: fontFamilyInterDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 43.2 / 36,
      color: scheme.textPrimary,
    );
  }
}
