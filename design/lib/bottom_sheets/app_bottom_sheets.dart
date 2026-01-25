import 'package:design/design.dart';
import 'package:flutter/material.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  AppBottomSheetType type = AppBottomSheetType.standard,
  required Widget child,
  bool showDragHandle = true,
  bool useRootNavigator = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    builder: (context) => switch (type) {
      AppBottomSheetType.floating => BaseFloatingBottomSheet(
        showDragHandle: showDragHandle,
        child: child,
      ),
      AppBottomSheetType.standard => BaseDefaultBottomSheet(
        showDragHandle: showDragHandle,
        child: child,
      ),
      AppBottomSheetType.fullScreen => SizedBox.expand(
    child: Column(
      children: [
        SizedBox(
          height: AppInsets.toolbarHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox.expand(),
          ),
        ),

        Expanded(
          child: BaseFullScreenBottomSheet(
            showDragHandle: showDragHandle,
            child: child,
          ),
        ),
      ],
    ),
  ),
    },
  );
}
