import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/features/root/presentation/widgets/app_bottom_navigation_bar.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          navigationShell,
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                child: const AppBottomNavigationBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
