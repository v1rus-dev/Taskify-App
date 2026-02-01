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

  static Color getIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.iconColor;
    }

    return lightScheme.iconColor;
  }

  static Color getPrimarySecondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return darkScheme.primarySecondary;
    }

    return lightScheme.primarySecondary;
  }
}

extension AppColorContextExtensions on BuildContext {
  Color get backgroundColor => AppColorExtensions.getBackgroundColor(this);
  Color get cardColor => AppColorExtensions.getCardColor(this);
  Color get textPrimaryColor => AppColorExtensions.getTextPrimaryColor(this);
  Color get textSecondaryColor =>
      AppColorExtensions.getTextSecondaryColor(this);
  Color get dividerColor => AppColorExtensions.getDividerColor(this);
  Color get primaryAccentColor =>
      AppColorExtensions.getPrimaryAccentColor(this);
  Color get buttonPrimaryBackgroundColor =>
      AppColorExtensions.getButtonPrimaryBackgroundColor(this);
  Color get buttonPrimaryTextColor =>
      AppColorExtensions.getButtonPrimaryTextColor(this);
  Color get buttonDisabledBackgroundColor =>
      AppColorExtensions.getButtonDisabledBackgroundColor(this);
  Color get buttonDisabledTextColor =>
      AppColorExtensions.getButtonDisabledTextColor(this);
  Color get shadowColor => AppColorExtensions.getShadowColor(this);
  Color get bottomSheetOverlayColor =>
      AppColorExtensions.getBottomSheetOverlayColor(this);
  Color get errorColor => AppColorExtensions.getErrorColor(this);
  Color get successColor => AppColorExtensions.getSuccessColor(this);
  Color get pendingColor => AppColorExtensions.getPendingColor(this);
  Color get bottomSheetDragHandleColor =>
      AppColorExtensions.getBottomSheetDragHandleColor(this);
  Color get iconColor => AppColorExtensions.getIconColor(this);
  Color get primarySecondaryColor =>
      AppColorExtensions.getPrimarySecondaryColor(this);
}
