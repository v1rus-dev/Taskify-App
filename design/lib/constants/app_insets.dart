import 'package:flutter/material.dart';

class AppInsets {
  const AppInsets._();

  static const double sheetHorizontalSmall = 20;
  static const double sheetHorizontal = 24;
  static const double sheetBottomSmall = 40;
  static const double sheetTitleTop = 16;
  static const double sheetTitleBottom = 28;
  static const double sheetBottom = 48;

  static const EdgeInsets sheetHorizontalSmallPadding = EdgeInsets.symmetric(
    horizontal: sheetHorizontalSmall,
  );

  static const EdgeInsets sheetHorizontalPadding = EdgeInsets.symmetric(
    horizontal: sheetHorizontal,
  );

  static const EdgeInsets sheetBottomPadding = EdgeInsets.only(
    bottom: 28,
    left: sheetHorizontalSmall,
    right: sheetHorizontalSmall,
  );
}
