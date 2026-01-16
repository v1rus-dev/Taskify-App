import 'package:design/design.dart';
import 'package:flutter/material.dart';

class AppColorExtensions {
  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.background;
    }

    return lightScheme.background;
  }

  static Color getCardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.card;
    }

    return lightScheme.card;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.textPrimary;
    }

    return lightScheme.textPrimary;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.textSecondary;
    }

    return lightScheme.textSecondary;
  }

  static Color getDividerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.divider;
    }

    return lightScheme.divider;
  }

  static Color getPrimaryAccentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.primaryAccent;
    }

    return lightScheme.primaryAccent;
  }

  static Color getButtonPrimaryBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.buttonPrimaryBackground;
    }

    return lightScheme.buttonPrimaryBackground;
  }

  static Color getButtonPrimaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.buttonPrimaryText;
    }

    return lightScheme.buttonPrimaryText;
  }

  static Color getButtonDisabledBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.buttonDisabledBackground;
    }

    return lightScheme.buttonDisabledBackground;
  }

  static Color getButtonDisabledTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.buttonDisabledText;
    }

    return lightScheme.buttonDisabledText;
  }

  static Color getShadowColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.shadow;
    }

    return lightScheme.shadow;
  }

  static Color getBottomSheetOverlayColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.bottomSheetOverlay;
    }

    return lightScheme.bottomSheetOverlay;
  }

  static Color getErrorColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.error;
    }

    return lightScheme.error;
  }

  static Color getSuccessColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.success;
    }

    return lightScheme.success;
  }

  static Color getPendingColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.pending;
    }

    return lightScheme.pending;
  }

  static Color getBottomSheetDragHandleColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.bottomSheetDragHandle;
    }

    return lightScheme.bottomSheetDragHandle;
  }
}