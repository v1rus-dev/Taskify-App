import 'package:flutter/material.dart';

class AppInsets {
  const AppInsets._();

  static const double sheetHorizontalSmall = 20;
  static const double sheetHorizontal = 24;
  static const double sheetVertical = 20;
  static const double sheetBottomSmall = 16;
  static const double sheetTitleTop = 16;
  static const double sheetTitleBottom = 28;
  static const double sheetBottom = 48;

  static const double toolbarHeight = 56;

  static const double floatingBottomSheetHorizontalPadding = 16;
  static const double floatingBottomSheetVerticalPadding = 8;

  static const EdgeInsets sheetHorizontalSmallPadding = EdgeInsets.symmetric(
    horizontal: sheetHorizontalSmall,
  );

  static const EdgeInsets sheetHorizontalPadding = EdgeInsets.symmetric(
    horizontal: sheetHorizontal,
  );

  static const EdgeInsets sheetVerticalPadding = EdgeInsets.symmetric(
    vertical: sheetVertical,
  );

  static const EdgeInsets sheetBottomPadding = EdgeInsets.only(
    bottom: 28,
    left: sheetHorizontalSmall,
    right: sheetHorizontalSmall,
  );
}
