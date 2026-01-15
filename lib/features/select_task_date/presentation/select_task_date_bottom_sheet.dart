import 'package:design/widgets/app_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SelectTaskDateBottomSheet extends ConsumerWidget {
  const SelectTaskDateBottomSheet({
    super.key,
    this.selectedDate,
    this.isAllDay,
  });

  final DateTime? selectedDate;
  final bool? isAllDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("When", style: theme.textTheme.displayMedium),
                // content
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: AppTextButton(text: "Save", onPressed: () {}),
        ),
      ],
    );
  }
}
