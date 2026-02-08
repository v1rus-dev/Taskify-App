import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

const lightScheme = AppColorScheme(
  background: Color(0xFFF9F9F9),
  card: Color(0xFFFFFFFF),
  textPrimary: Color(0xFF121212),
  textSecondary: Color(0xFFA6A6A6),
  divider: Color(0x0D000000),
  primaryAccent: Color(0xFF6682FF),
  buttonPrimaryBackground: Color(0xFF6682FF),
  buttonPrimaryText: Colors.white,
  buttonDisabledBackground: Color(0xFFEDEDED),
  buttonDisabledText: Color(0xFFB0B0B0),
  shadow: Color(0x0D000000),
  bottomSheetOverlay: Color(0x33000000),
  error: Color(0xFFD32F2F),
  success: Color(0xFF2E7D32),
  pending: Color(0xFFFFB300),
  bottomSheetDragHandle: Color(0xFFD9D9D9),
  iconColor: Color(0xFFC9C9C9),
  primarySecondary: Color(0x99B2C6FF),
  warningInfo: Color(0xFFF59E0B),
);

const darkScheme = AppColorScheme(
  background: Color(0xFF121212),
  card: Color(0xFF1E1E1E),
  textPrimary: Colors.white,
  textSecondary: Color(0xFFA6A6A6),
  divider: Color(0x1FFFFFFF), // 12% white
  primaryAccent: Color(0xFF6682FF),
  buttonPrimaryBackground: Color(0xFF6682FF),
  buttonPrimaryText: Colors.white,
  buttonDisabledBackground: Color(0xFF2E2E2E),
  buttonDisabledText: Color(0xFF7A7A7A),
  shadow: Color(0x33000000), // тени в dark
  bottomSheetOverlay: Color(0x66000000), // overlay немного сильнее
  error: Color(0xFFEF5350),
  success: Color(0xFF81C784),
  pending: Color(0xFFFFB300),
  bottomSheetDragHandle: Color(0xFFFFFFFF),
  iconColor: Color(0xFFC9C9C9),
  primarySecondary: Color(0x99B2C6FF),
  warningInfo: Color(0xFFF59E0B),
);
