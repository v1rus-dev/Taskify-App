import 'dart:async';

class AppDialogActionConfig<T> {
  const AppDialogActionConfig({
    required this.title,
    this.result,
    this.onPressed,
  });

  final String title;
  final T? result;
  final FutureOr<void> Function()? onPressed;
}
