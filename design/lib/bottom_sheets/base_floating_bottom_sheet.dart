import 'package:design/design.dart';
import 'package:flutter/material.dart';

class BaseFloatingBottomSheet extends StatelessWidget {
  const BaseFloatingBottomSheet({super.key, required this.child, this.showDragHandle = true});

  final bool showDragHandle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: kThemeAnimationDuration,
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: AppInsets.floatingBottomSheetHorizontalPadding,
          top: AppInsets.floatingBottomSheetVerticalPadding,
          right: AppInsets.floatingBottomSheetHorizontalPadding,
          bottom:
              AppInsets.floatingBottomSheetVerticalPadding + keyboardInset,
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
