import 'package:flutter/material.dart';

class AppRadius {
  const AppRadius._();

  static const double defaultCardRadius = 16;
  static const double bottomSheet = 36;

  static const BorderRadius bottomSheetTop = BorderRadius.vertical(
    top: Radius.circular(bottomSheet),
  );

  static const BorderRadius bottomSheetAll = BorderRadius.all(
    Radius.circular(bottomSheet),
  );
  
  static const BorderRadius defaultCard = BorderRadius.all(Radius.circular(defaultCardRadius));
}
