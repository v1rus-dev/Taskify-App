import 'package:flutter/material.dart';

Future<void> hideKeyboardAndWait(BuildContext context) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 16));
    if (!context.mounted) return false;
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  });
}

Future<void> unfocusAndThen(
  BuildContext context,
  Future<void> Function() action,
) async {

  if (MediaQuery.viewInsetsOf(context).bottom == 0) {
    await action();
    return;
  }

  FocusManager.instance.primaryFocus?.unfocus();

  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 16));
    if (!context.mounted) return false;
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  });

  await action();
}