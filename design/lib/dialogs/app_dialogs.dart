import 'package:flutter/material.dart';
import 'package:design/dialogs/widgets/app_loading_dialog.dart';

bool _isLoadingDialogShown = false;

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
