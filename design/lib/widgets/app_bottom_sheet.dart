import 'package:design/design.dart';
import 'package:flutter/material.dart';

enum AppBottomSheetType { standard, floating, fullScreen }

Future<T?> showStandardBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  bool isScrollable = false,
  bool expandScrollable = false,
  ScrollPhysics? scrollPhysics,
  double? minContentHeight,
  double? maxContentHeight,
}) {
  return _showAppModalBottomSheet<T>(
    context: context,
    child: child,
    type: AppBottomSheetType.standard,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    isScrollable: isScrollable,
    expandScrollable: expandScrollable,
    scrollPhysics: scrollPhysics,
    minContentHeight: minContentHeight,
    maxContentHeight: maxContentHeight,
  );
}

Future<T?> showFloatingBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  bool isScrollable = false,
  bool expandScrollable = false,
  ScrollPhysics? scrollPhysics,
  double? minContentHeight,
  double? maxContentHeight,
  EdgeInsets? padding,
}) {
  return _showAppModalBottomSheet<T>(
    context: context,
    child: child,
    type: AppBottomSheetType.floating,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    isScrollable: isScrollable,
    expandScrollable: expandScrollable,
    scrollPhysics: scrollPhysics,
    minContentHeight: minContentHeight,
    maxContentHeight: maxContentHeight,
    floatingPadding: padding,
  );
}

Future<T?> showFullScreenBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  bool isScrollable = false,
  bool expandScrollable = false,
  ScrollPhysics? scrollPhysics,
  double? minContentHeight,
  double? maxContentHeight,
}) {
  return _showAppModalBottomSheet<T>(
    context: context,
    child: child,
    type: AppBottomSheetType.fullScreen,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    isScrollable: isScrollable,
    expandScrollable: expandScrollable,
    scrollPhysics: scrollPhysics,
    minContentHeight: minContentHeight,
    maxContentHeight: maxContentHeight,
    isScrollControlled: true,
  );
}

Future<T?> _showAppModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  required AppBottomSheetType type,
  bool isScrollControlled = false,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  bool isScrollable = false,
  bool expandScrollable = false,
  ScrollPhysics? scrollPhysics,
  double? minContentHeight,
  double? maxContentHeight,
  EdgeInsets? floatingPadding,
  Color? backgroundColor,
  Color? barrierColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: false,
    useRootNavigator: useRootNavigator,
    backgroundColor: _backgroundColorForType(context, type, backgroundColor),
    shape: _shapeForType(type),
    barrierColor:
        barrierColor ?? AppColorExtensions.getBottomSheetOverlayColor(context),
    builder: (context) {
      final content = _AppBottomSheetContent(
        showDragHandle: showDragHandle,
        isScrollable: isScrollable,
        expandScrollable: expandScrollable,
        scrollPhysics: scrollPhysics,
        minContentHeight: minContentHeight,
        maxContentHeight: maxContentHeight,
        includeBottomSafeArea: type == AppBottomSheetType.standard
            ? useSafeArea
            : false,
        child: child,
      );

      if (type == AppBottomSheetType.floating) {
        final padding = _floatingPadding(context, floatingPadding, useSafeArea);
        return Padding(
          padding: padding,
          child: Material(
            color:
                backgroundColor ??
                AppColorExtensions.getBackgroundColor(context),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.bottomSheetAll,
            ),
            clipBehavior: Clip.antiAlias,
            child: content,
          ),
        );
      }

      return content;
    },
  );
}

class AppBottomSheetScaffold extends StatelessWidget {
  const AppBottomSheetScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.fullScreen = false,
    this.fullScreenFraction = 1.0,
    this.bodyScrollable = false,
    this.bodyPadding = EdgeInsets.zero,
    this.bottomPadding = EdgeInsets.zero,
    this.scrollPhysics,
    this.useSafeArea = true,
  });

  final Widget body;
  final Widget? bottom;
  final bool fullScreen;
  final double fullScreenFraction;
  final bool bodyScrollable;
  final EdgeInsetsGeometry bodyPadding;
  final EdgeInsetsGeometry bottomPadding;
  final ScrollPhysics? scrollPhysics;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = body;

    if (bodyScrollable) {
      bodyContent = SingleChildScrollView(
        physics: scrollPhysics,
        child: Padding(padding: bodyPadding, child: bodyContent),
      );
    } else if (bodyPadding != EdgeInsets.zero) {
      bodyContent = Padding(padding: bodyPadding, child: bodyContent);
    }

    final content = Column(
      mainAxisSize: fullScreen ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (fullScreen) Expanded(child: bodyContent) else bodyContent,
        if (bottom != null) Padding(padding: bottomPadding, child: bottom),
      ],
    );

    if (fullScreen) {
      final mediaQuery = MediaQuery.of(context);
      final height = mediaQuery.size.height * fullScreenFraction;
      final topSafeArea = useSafeArea ? mediaQuery.viewPadding.top : 0.0;
      final adjustedHeight = (height - topSafeArea).clamp(0.0, height);

      return Padding(
        padding: EdgeInsets.only(top: topSafeArea),
        child: SizedBox(height: adjustedHeight, child: content),
      );
    }

    return useSafeArea ? SafeArea(child: content) : content;
  }
}

ShapeBorder? _shapeForType(AppBottomSheetType type) {
  switch (type) {
    case AppBottomSheetType.floating:
      return null;
    case AppBottomSheetType.standard:
    case AppBottomSheetType.fullScreen:
      return const RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheetTop,
      );
  }
}

Color _backgroundColorForType(
  BuildContext context,
  AppBottomSheetType type,
  Color? color,
) {
  if (type == AppBottomSheetType.floating) {
    return Colors.transparent;
  }

  return color ?? AppColorExtensions.getBackgroundColor(context);
}

EdgeInsets _floatingPadding(
  BuildContext context,
  EdgeInsets? padding,
  bool includeSafeArea,
) {
  final basePadding = padding ?? const EdgeInsets.all(16);
  final safeBottom = includeSafeArea
      ? MediaQuery.viewPaddingOf(context).bottom
      : 0.0;

  return basePadding.copyWith(bottom: basePadding.bottom + safeBottom);
}

class _AppBottomSheetContent extends StatelessWidget {
  const _AppBottomSheetContent({
    required this.child,
    required this.showDragHandle,
    required this.isScrollable,
    required this.expandScrollable,
    required this.scrollPhysics,
    required this.minContentHeight,
    required this.maxContentHeight,
    required this.includeBottomSafeArea,
  });

  final Widget child;
  final bool showDragHandle;
  final bool isScrollable;
  final bool expandScrollable;
  final ScrollPhysics? scrollPhysics;
  final double? minContentHeight;
  final double? maxContentHeight;
  final bool includeBottomSafeArea;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafeArea = includeBottomSafeArea
        ? MediaQuery.viewPaddingOf(context).bottom
        : 0.0;
    Widget content = child;

    if (isScrollable) {
      content = SingleChildScrollView(physics: scrollPhysics, child: content);
    }

    if (minContentHeight != null || maxContentHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minContentHeight ?? 0,
          maxHeight: maxContentHeight ?? double.infinity,
        ),
        child: content,
      );
    }

    if (expandScrollable) {
      content = SizedBox(width: double.infinity, child: content);
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset + bottomSafeArea),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dragHandleHeight = 28.0;
          final maxHeight = constraints.hasBoundedHeight
              ? (constraints.maxHeight -
                        (showDragHandle ? dragHandleHeight : 0.0))
                    .clamp(0.0, double.infinity)
              : null;

          final sizedContent = maxHeight == null
              ? content
              : ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: content,
                );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle) _BottomSheetDragHandle(),
              sizedContent,
            ],
          );
        },
      ),
    );
  }
}

class _BottomSheetDragHandle extends StatelessWidget {
  const _BottomSheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Container(
        height: 4,
        width: 77,
        decoration: BoxDecoration(
          color: AppColorExtensions.getBottomSheetDragHandleColor(context),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
