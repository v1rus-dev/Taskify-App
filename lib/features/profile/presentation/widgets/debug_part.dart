import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/router_paths.dart';

class DebugPart extends StatelessWidget {
  const DebugPart({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const Gap(12),
        CardWithActions(
          actions: [
            CardActionEntry(
              CardAction(
                title: 'Debug',
                onPressed: () => context.push(RouterPaths.debug),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
