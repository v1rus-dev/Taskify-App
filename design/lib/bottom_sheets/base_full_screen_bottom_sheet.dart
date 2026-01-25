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
    final mq = MediaQuery.of(context);
    final bottomPadding = mq.padding.bottom;

    final sheetHeight = mq.size.height - AppInsets.toolbarHeight;

    return SizedBox(
      height: sheetHeight,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
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
