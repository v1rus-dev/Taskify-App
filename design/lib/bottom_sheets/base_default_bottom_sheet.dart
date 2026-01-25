import 'package:flutter/material.dart';
import 'package:design/design.dart';

class BaseDefaultBottomSheet extends StatelessWidget {
  const BaseDefaultBottomSheet({
    super.key,
    required this.child,
    this.showDragHandle = true,
  });

  final bool showDragHandle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsetsGeometry.only(bottom: bottomPadding),
        decoration: BoxDecoration(
          color: AppColorExtensions.getBackgroundColor(context),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
        child: Wrap(
          children: [
            if (showDragHandle) AppDragHandle(),
            child,
          ],
        ),
      ),
    );
  }
}
