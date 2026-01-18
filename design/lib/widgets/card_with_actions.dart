import 'package:design/models/card_action.dart';
import 'package:design/themes/color/app_color_extensions.dart';
import 'package:design/constants/app_icons.dart';
import 'package:design/widgets/app_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWithActions extends StatefulWidget {
  const CardWithActions({
    super.key,
    required this.actions,
    this.animatable = false,
    this.withAnimationExpanded = false,
  });

  final List<CardAction> actions;
  final bool animatable;
  final bool withAnimationExpanded;

  @override
  State<CardWithActions> createState() => _CardWithActionsState();
}

class _CardWithActionsState extends State<CardWithActions> {
  BorderRadius _borderRadiusForPosition(_ActionPositionType positionType) {
    switch (positionType) {
      case _ActionPositionType.top:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case _ActionPositionType.bottom:
        return const BorderRadius.vertical(bottom: Radius.circular(16));
      case _ActionPositionType.middle:
        return BorderRadius.zero;
      case _ActionPositionType.single:
        return BorderRadius.circular(16);
    }
  }

  Widget _buildAction(CardAction action, _ActionPositionType positionType) {
    final theme = Theme.of(context);
    final trailing = action.description != null
        ? Text(
            action.description!,
            textAlign: TextAlign.right,
            style: theme.textTheme.labelLarge!.copyWith(
              color:
                  action.descriptionColor ??
                  AppColorExtensions.getTextPrimaryColor(context),
              fontWeight: FontWeight.w700,
            ),
          )
        : action.icon != null
        ? action.icon!
        : SizedBox.shrink();
    final radius = _borderRadiusForPosition(positionType);
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: action.isEnabled ? action.onPressed : null,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        action.title,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: action.titleColor ?? AppColorExtensions.getTextPrimaryColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AppIcons.arrowRightSmall,
                      package: AppIcons.packageName,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < widget.actions.length; i++) {
      final positionType = i == 0
          ? widget.actions.length == 1
          ? _ActionPositionType.single
          : _ActionPositionType.top
          : i == widget.actions.length - 1
          ? _ActionPositionType.bottom
          : _ActionPositionType.middle;
      children.add(_buildAction(widget.actions[i], positionType));
      if (i != widget.actions.length - 1) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: AppColorExtensions.getDividerColor(context),
          ),
        );
      }
    }
    final content = Column(children: children);
    return AppShadow(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColorExtensions.getCardColor(context),
        ),
        child: widget.animatable
            ? AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: content,
              )
            : content,
      ),
    );
  }
}

enum _ActionPositionType { top, middle, bottom, single }
