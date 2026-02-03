import 'package:design/constants/app_radius.dart';
import 'package:design/models/card_action.dart';
import 'package:design/themes/color/app_color_extensions.dart';
import 'package:design/constants/app_icons.dart';
import 'package:design/widgets/app_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

sealed class CardWithActionsEntry {
  const CardWithActionsEntry();
}

class CardActionEntry extends CardWithActionsEntry {
  const CardActionEntry(this.action);
  final CardAction action;
}

class CardCustomEntry extends CardWithActionsEntry {
  const CardCustomEntry({
    required this.child,
    this.onPressed,
    this.showTrailingIcon = true,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final bool showTrailingIcon;
}

class CardWithActions extends StatefulWidget {
  const CardWithActions({
    super.key,
    required this.actions,
    this.animatable = false,
    this.withAnimationExpanded = false,
    this.showAppShadow = true,
  });

  final List<CardWithActionsEntry> actions;
  final bool animatable;
  final bool withAnimationExpanded;
  final bool showAppShadow;

  @override
  State<CardWithActions> createState() => _CardWithActionsState();
}

class _CardWithActionsState extends State<CardWithActions> {
  BorderRadius _borderRadiusForPosition(_ActionPositionType positionType) {
    switch (positionType) {
      case _ActionPositionType.top:
        return const BorderRadius.vertical(top: Radius.circular(AppRadius.defaultCardRadius));
      case _ActionPositionType.bottom:
        return const BorderRadius.vertical(bottom: Radius.circular(AppRadius.defaultCardRadius));
      case _ActionPositionType.middle:
        return BorderRadius.zero;
      case _ActionPositionType.single:
        return BorderRadius.circular(AppRadius.defaultCardRadius);
    }
  }

  Widget _buildEntry(
    CardWithActionsEntry entry,
    _ActionPositionType positionType,
  ) {
    return switch (entry) {
      CardActionEntry(:final action) => _buildAction(action, positionType),
      CardCustomEntry() => _buildCustom(entry, positionType),
    };
  }

  Widget _buildCustom(CardCustomEntry entry, _ActionPositionType positionType) {
    const padding = EdgeInsets.all(16);
    final radius = _borderRadiusForPosition(positionType);
    final content = Padding(
      padding: padding,
      child: entry.showTrailingIcon
          ? Row(
              children: [
                Expanded(child: entry.child),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  AppIcons.arrowRightSmall,
                  package: AppIcons.packageName,
                  width: 24,
                  height: 24,
                ),
              ],
            )
          : entry.child,
    );
    if (entry.onPressed == null) {
      return ClipRRect(
        borderRadius: radius,
        child: content,
      );
    }
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: entry.onPressed,
        borderRadius: radius,
        child: content,
      ),
    );
  }

  Widget _buildAction(CardAction action, _ActionPositionType positionType) {
    final theme = Theme.of(context);
    final trailing = action.description != null
        ? Text(
            action.description!,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium!.copyWith(
              color:
                  action.descriptionColor ??
                  AppColorExtensions.getTextPrimaryColor(context),
              fontWeight: FontWeight.bold,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: action.titleColor ?? AppColorExtensions.getTextPrimaryColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (action.showArrow) ...[
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        AppIcons.arrowRightSmall,
                        package: AppIcons.packageName,
                        width: 24,
                        height: 24,
                      ),
                    ],
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
      children.add(_buildEntry(widget.actions[i], positionType));
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
      enabled: widget.showAppShadow,
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
