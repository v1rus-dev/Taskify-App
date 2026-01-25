import 'package:design/design.dart';
import 'package:flutter/material.dart';

class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 4,
            width: 72,
            decoration: BoxDecoration(
              color: AppColorExtensions.getBottomSheetDragHandleColor(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
