import 'package:design/design.dart';
import 'package:flutter/material.dart';

class BaseFloatingBottomSheet extends StatelessWidget {
  const BaseFloatingBottomSheet({super.key, required this.child, this.showDragHandle = true});

  final bool showDragHandle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: AppInsets.floatingBottomSheetHorizontalPadding,
          vertical: AppInsets.floatingBottomSheetVerticalPadding,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColorExtensions.getBackgroundColor(context),
            borderRadius: BorderRadius.circular(AppRadius.bottomSheet),
          ),
          child: Wrap(
            children: [
              if (showDragHandle) AppDragHandle(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
