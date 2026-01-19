import 'package:design/design.dart';
import 'package:flutter/material.dart';

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = false,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  bool isScrollable = false,
  bool expandScrollable = false,
  ScrollPhysics? scrollPhysics,
  double? minContentHeight,
  double? maxContentHeight,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
  ),
  Color? backgroundColor,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useSafeArea: false,
  useRootNavigator: useRootNavigator,
  backgroundColor:
      backgroundColor ?? AppColorExtensions.getBackgroundColor(context),
  shape: shape,
  builder: (context) {
    return _AppBottomSheetContent(
      showDragHandle: showDragHandle,
      isScrollable: isScrollable,
      expandScrollable: expandScrollable,
      scrollPhysics: scrollPhysics,
      minContentHeight: minContentHeight,
      maxContentHeight: maxContentHeight,
      includeBottomSafeArea: useSafeArea,
      child: child,
    );
  },
);

class AppBottomSheetScaffold extends StatelessWidget {
  const AppBottomSheetScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.fullScreen = false,
    this.bodyScrollable = false,
    this.bodyPadding = EdgeInsets.zero,
    this.bottomPadding = EdgeInsets.zero,
    this.scrollPhysics,
    this.useSafeArea = true,
  });

  final Widget body;
  final Widget? bottom;
  final bool fullScreen;
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
        child: Padding(
          padding: bodyPadding,
          child: bodyContent,
        ),
      );
    } else if (bodyPadding != EdgeInsets.zero) {
      bodyContent = Padding(
        padding: bodyPadding,
        child: bodyContent,
      );
    }

    final content = Column(
      mainAxisSize: fullScreen ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (fullScreen)
          Expanded(child: bodyContent)
        else
          bodyContent,
        if (bottom != null)
          Padding(
            padding: bottomPadding,
            child: bottom,
          ),
      ],
    );

    final sizedContent = fullScreen
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: content,
          )
        : content;

    if (!useSafeArea) {
      return sizedContent;
    }

    return SafeArea(child: sizedContent);
  }
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
      content = SingleChildScrollView(
        physics: scrollPhysics,
        child: content,
      );
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
      content = SizedBox(
        width: double.infinity,
        child: content,
      );
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset + bottomSafeArea),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _BottomSheetDragHandle(),
          content,
        ],
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
