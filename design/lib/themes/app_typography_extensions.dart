import 'package:design/themes/app_typography.dart';
import 'package:design/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final AppColorSchemeExtension colorScheme;

  const AppTypographyExtension(this.colorScheme);

  TextTheme get textTheme => TextTheme(
        displayLarge: AppTypography.header(colorScheme),
        displayMedium: AppTypography.header(colorScheme),
        titleLarge: AppTypography.screenTitle(colorScheme),
        titleMedium: AppTypography.title(colorScheme),
        titleSmall: AppTypography.title(colorScheme),
        bodyMedium: AppTypography.body(colorScheme),
        bodyLarge: AppTypography.bodyLarge(colorScheme),
        bodySmall: AppTypography.caption(colorScheme),
        labelLarge: AppTypography.button(colorScheme),
        labelSmall: AppTypography.tag(colorScheme),
      );

  TextStyle get headlineLarge => textTheme.displayLarge!;
  TextStyle get headlineMedium => textTheme.displayMedium!;
  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleSmall => textTheme.titleSmall!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodySmall => textTheme.bodySmall!;
  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelSmall => textTheme.labelSmall!;

  @override
  AppTypographyExtension copyWith({AppColorSchemeExtension? colorScheme}) {
    return AppTypographyExtension(colorScheme ?? this.colorScheme);
  }

  @override
  AppTypographyExtension lerp(ThemeExtension<AppTypographyExtension>? other, double t) {
    if (other is! AppTypographyExtension) return this;
    final lerpedScheme = colorScheme.lerp(other.colorScheme, t);
    return AppTypographyExtension(lerpedScheme);
  }
}
