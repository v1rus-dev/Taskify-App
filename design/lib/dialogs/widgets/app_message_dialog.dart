import 'package:design/constants/constants.dart';
import 'package:design/dialogs/models/models.dart';
import 'package:design/themes/themes.dart';
import 'package:design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class AppMessageDialog extends StatelessWidget {
  const AppMessageDialog({
    required this.title,
    required this.description,
    required this.primaryActionTitle,
    required this.onPrimaryActionPressed,
    required this.canPop,
    this.secondaryActionTitle,
    this.onSecondaryActionPressed,
    this.tone = AppDialogTone.info,
    this.topIconAssetPath,
    this.topIconColor,
    super.key,
  });

  final String title;
  final String description;
  final String primaryActionTitle;
  final VoidCallback onPrimaryActionPressed;
  final String? secondaryActionTitle;
  final VoidCallback? onSecondaryActionPressed;
  final bool canPop;
  final AppDialogTone tone;
  final String? topIconAssetPath;
  final Color? topIconColor;

  bool get _isErrorTone => tone == AppDialogTone.error;
  bool get _hasTopIcon => topIconAssetPath != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = AppColorExtensions.getErrorColor(context);
    final cardColor = AppColorExtensions.getCardColor(context);
    final textPrimaryColor = AppColorExtensions.getTextPrimaryColor(context);
    final textSecondaryColor = AppColorExtensions.getTextSecondaryColor(context);

    return PopScope(
      canPop: canPop,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: AppRadius.defaultCard,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_hasTopIcon) ...[
                    SvgPicture.asset(
                      topIconAssetPath!,
                      package: AppIcons.packageName,
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(
                        topIconColor ?? (_isErrorTone ? errorColor : textPrimaryColor),
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(12),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: _isErrorTone ? errorColor : textPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  if (secondaryActionTitle != null &&
                      onSecondaryActionPressed != null)
                    _buildTwoActions(
                      secondaryActionTitle: secondaryActionTitle!,
                      textSecondaryColor: textSecondaryColor,
                      errorColor: errorColor,
                      primaryColor: context.primaryAccentColor,
                      onSecondaryActionPressed: onSecondaryActionPressed!,
                      onPrimaryActionPressed: onPrimaryActionPressed,
                    )
                  else
                    AppTextButton(
                      text: primaryActionTitle,
                      onPressed: onPrimaryActionPressed,
                      backgroundColor: _isErrorTone
                          ? errorColor.withValues(alpha: 0.85)
                          : null,
                      textColor: _isErrorTone ? Colors.white : null,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoActions({
    required String secondaryActionTitle,
    required Color textSecondaryColor,
    required Color errorColor,
    required Color primaryColor,
    required VoidCallback onSecondaryActionPressed,
    required VoidCallback onPrimaryActionPressed,
  }) {
    final secondaryAction = _DialogTextAction(
      title: secondaryActionTitle,
      textColor: textSecondaryColor,
      onPressed: onSecondaryActionPressed,
    );
    final primaryAction = _DialogTextAction(
      title: primaryActionTitle,
      textColor: _isErrorTone ? errorColor : primaryColor,
      onPressed: onPrimaryActionPressed,
    );

    if (_hasTopIcon) {
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            secondaryAction,
            primaryAction,
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        secondaryAction,
        const Gap(4),
        primaryAction,
      ],
    );
  }
}

class _DialogTextAction extends StatelessWidget {
  const _DialogTextAction({
    required this.title,
    required this.onPressed,
    required this.textColor,
  });

  final String title;
  final VoidCallback onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
