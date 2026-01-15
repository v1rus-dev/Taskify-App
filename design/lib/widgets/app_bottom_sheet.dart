import 'package:design/design.dart';
import 'package:flutter/material.dart';

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = false,
  bool showDragHandle = true,
  bool useSafeArea = true,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
  ),
  Color? backgroundColor,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useSafeArea: useSafeArea,
  backgroundColor:
      backgroundColor ?? AppColorExtensions.getBackgroundColor(context),
  shape: shape,
  builder: (context) {
    return child;
  },
);

/**
 * Padding( padding: const EdgeInsets.only(top: 16), child: Container( height: 4, width: 77, decoration: BoxDecoration( color: AppColorExtensions.getBottomSheetDragHandleColor(context), borderRadius: BorderRadius.circular(2), ), ), ),
 */
