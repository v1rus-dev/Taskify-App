import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/router_paths.dart';

class DebugScreenPage extends StatelessWidget {
  const DebugScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DebugScreen();
  }
}

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  void _onBackPressed(BuildContext context) {
    context.pop();
  }

  void _openNotificationsDebug(BuildContext context) {
    context.push(RouterPaths.debugNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: 'Debug',
        onBack: () => _onBackPressed(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CardWithActions(
            actions: [
              CardActionEntry(
                CardAction(
                  title: 'Notifications',
                  description: 'Pending + test reminders',
                  onPressed: () => _openNotificationsDebug(context),
                ),
              ),
            ],
            showAppShadow: false,
          ),
        ),
      ),
    );
  }
}
