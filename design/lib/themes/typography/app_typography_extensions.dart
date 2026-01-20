import 'package:design/themes/typography/app_typography.dart';
import 'package:design/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final AppColorSchemeExtension colorScheme;

  const AppTypographyExtension(this.colorScheme);

  TextTheme get textTheme => TextTheme(
    headlineLarge: AppTypography.headlineLarge(colorScheme),
    headlineMedium: AppTypography.headlineMedium(colorScheme),
    titleLarge: AppTypography.titleLarge(colorScheme),
    titleMedium: AppTypography.titleMedium(colorScheme),
    titleSmall: AppTypography.titleSmall(colorScheme),
    bodyLarge: AppTypography.bodyLarge(colorScheme),
    bodyMedium: AppTypography.bodyMedium(colorScheme),
    bodySmall: AppTypography.bodySmall(colorScheme),
    labelLarge: AppTypography.labelLarge(colorScheme),
    labelMedium: AppTypography.labelMedium(colorScheme),
    labelSmall: AppTypography.labelSmall(colorScheme),
  );

  TextSelectionThemeData get textSelectionTheme => TextSelectionThemeData(
    cursorColor: colorScheme.primaryAccent,
    selectionColor: colorScheme.primaryAccent.withValues(alpha: 0.2),
    selectionHandleColor: colorScheme.primaryAccent,
  );

  TextStyle get headlineLarge => textTheme.headlineLarge!;
  TextStyle get headlineMedium => textTheme.headlineMedium!;
  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleSmall => textTheme.titleSmall!;
  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;
  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelMedium => textTheme.labelMedium!;
  TextStyle get labelSmall => textTheme.labelSmall!;

  @override
  AppTypographyExtension copyWith({AppColorSchemeExtension? colorScheme}) {
    return AppTypographyExtension(colorScheme ?? this.colorScheme);
  }

  @override
  AppTypographyExtension lerp(
    ThemeExtension<AppTypographyExtension>? other,
    double t,
  ) {
    if (other is! AppTypographyExtension) return this;
    final lerpedScheme = colorScheme.lerp(other.colorScheme, t);
    return AppTypographyExtension(lerpedScheme);
  }
}
