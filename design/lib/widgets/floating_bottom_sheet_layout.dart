import 'package:design/constants/constants.dart';
import 'package:flutter/material.dart';

class FloatingBottomSheetLayout extends StatelessWidget {
  const FloatingBottomSheetLayout({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppInsets.sheetHorizontal,
        vertical: AppInsets.sheetVertical,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
