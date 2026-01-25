import 'package:design/design.dart';
import 'package:flutter/material.dart';

class BaseFullScreenBottomSheet extends StatelessWidget {
  const BaseFullScreenBottomSheet({
    super.key,
    required this.child,
    this.showDragHandle = true,
  });

  final bool showDragHandle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: const EdgeInsets.only(top: AppInsets.toolbarHeight),
      child: Container(
        padding: EdgeInsetsGeometry.only(bottom: bottomPadding),
        decoration: BoxDecoration(
          color: AppColorExtensions.getBackgroundColor(context),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
        child: Column(
          children: [
            if (showDragHandle) AppDragHandle(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
