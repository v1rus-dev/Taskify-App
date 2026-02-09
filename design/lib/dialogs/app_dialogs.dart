import 'package:flutter/material.dart';
import 'package:design/constants/app_icons.dart';
import 'package:design/dialogs/models/models.dart';
import 'package:design/dialogs/widgets/app_loading_dialog.dart';
import 'package:design/dialogs/widgets/app_message_dialog.dart';

bool _isLoadingDialogShown = false;

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String description,
  required AppDialogActionConfig<T> primaryAction,
  AppDialogActionConfig<T>? secondaryAction,
  AppDialogTone tone = AppDialogTone.info,
  bool barrierDismissible = true,
  String? topIconAssetPath,
  Color? topIconColor,
}) {
  Future<void> onActionTap(AppDialogActionConfig<T> action) async {
    await action.onPressed?.call();
    if (!context.mounted) {
      return;
    }

    Navigator.of(context, rootNavigator: true).pop(action.result);
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: true,
    builder: (dialogContext) => AppMessageDialog(
      title: title,
      description: description,
      tone: tone,
      canPop: barrierDismissible,
      primaryActionTitle: primaryAction.title,
      onPrimaryActionPressed: () => onActionTap(primaryAction),
      secondaryActionTitle: secondaryAction?.title,
      onSecondaryActionPressed: secondaryAction == null
          ? null
          : () => onActionTap(secondaryAction),
      topIconAssetPath: topIconAssetPath,
      topIconColor: topIconColor,
    ),
  );
}

Future<void> showAppInfoDialog({
  required BuildContext context,
  required String title,
  required String description,
  String? buttonTitle,
  VoidCallback? onPressed,
}) async {
  final localizations = MaterialLocalizations.of(context);

  await showAppDialog<void>(
    context: context,
    title: title,
    description: description,
    barrierDismissible: true,
    primaryAction: AppDialogActionConfig<void>(
      title: buttonTitle ?? localizations.okButtonLabel,
      onPressed: onPressed,
    ),
  );
}

Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  String? confirmButtonTitle,
  String? cancelButtonTitle,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  final localizations = MaterialLocalizations.of(context);

  return showAppDialog<bool>(
    context: context,
    title: title,
    description: description,
    barrierDismissible: barrierDismissible,
    primaryAction: AppDialogActionConfig<bool>(
      title: confirmButtonTitle ?? localizations.okButtonLabel,
      result: true,
      onPressed: onConfirm,
    ),
    secondaryAction: AppDialogActionConfig<bool>(
      title: cancelButtonTitle ?? localizations.cancelButtonLabel,
      result: false,
      onPressed: onCancel,
    ),
  );
}

Future<bool?> showAppErrorDialog({
  required BuildContext context,
  required String title,
  required String description,
  String? primaryButtonTitle,
  String? secondaryButtonTitle,
  VoidCallback? onPrimaryPressed,
  VoidCallback? onSecondaryPressed,
  bool? barrierDismissible,
}) {
  final localizations = MaterialLocalizations.of(context);

  return showAppDialog<bool>(
    context: context,
    title: title,
    description: description,
    tone: AppDialogTone.error,
    barrierDismissible:
        barrierDismissible ?? (secondaryButtonTitle != null),
    topIconAssetPath: AppIcons.warningInfo,
    primaryAction: AppDialogActionConfig<bool>(
      title: primaryButtonTitle ?? localizations.okButtonLabel,
      result: true,
      onPressed: onPrimaryPressed,
    ),
    secondaryAction: secondaryButtonTitle == null
        ? null
        : AppDialogActionConfig<bool>(
            title: secondaryButtonTitle,
            result: false,
            onPressed: onSecondaryPressed,
          ),
  );
}

Future<void> showAppLoadingDialog({
  required BuildContext context,
}) async {
  if (_isLoadingDialogShown) {
    return;
  }

  _isLoadingDialogShown = true;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    useRootNavigator: true,
    builder: (context) => const AppLoadingDialog(),
  );
}

void dismissAppLoadingDialog(BuildContext context) {
  if (!_isLoadingDialogShown) {
    return;
  }

  final navigator = Navigator.of(context, rootNavigator: true);
  if (!navigator.canPop()) {
    return;
  }

  _isLoadingDialogShown = false;
  navigator.pop();
}
