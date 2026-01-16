import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

const lightScheme = AppColorScheme(
  background: Color(0xFFF9F9F9),
  card: Color(0xFFFFFFFF),
  textPrimary: Color(0xFF121212),
  textSecondary: Color(0x66121212),
  divider: Color(0x0D000000),
  primaryAccent: Color(0x99002FFF),
  buttonPrimaryBackground: Color(0x99002FFF),
  buttonPrimaryText: Colors.white,
  buttonDisabledBackground: Color(0xFFEDEDED),
  buttonDisabledText: Color(0xFFB0B0B0),
  shadow: Color(0x0D000000),
  bottomSheetOverlay: Color(0x33000000),
  error: Color(0xFFD32F2F),
  success: Color(0xFF2E7D32),
  pending: Color(0xFFFFB300),
  bottomSheetDragHandle: Color(0xFFD9D9D9),
);

const darkScheme = AppColorScheme(
  background: Color(0xFF121212),
  card: Color(0xFF1E1E1E),
  textPrimary: Colors.white,
  textSecondary: Color(0xB3FFFFFF), // 70% alpha
  divider: Color(0x1FFFFFFF), // 12% white
  primaryAccent: Color(0xFF3366FF),
  buttonPrimaryBackground: Color(0xFF3366FF),
  buttonPrimaryText: Colors.white,
  buttonDisabledBackground: Color(0xFF2E2E2E),
  buttonDisabledText: Color(0xFF7A7A7A),
  shadow: Color(0x33000000), // тени в dark
  bottomSheetOverlay: Color(0x66000000), // overlay немного сильнее
  error: Color(0xFFEF5350),
  success: Color(0xFF81C784),
  pending: Color(0xFFFFB300),
  bottomSheetDragHandle: Color(0xFFFFFFFF),
);