import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:taskify/features/root/presentation/widgets/app_bottom_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  void _showAuthLoadingDialog(BuildContext context) {
    showAppLoadingDialog(context: context);
  }

  void _dismissAuthLoadingDialog(BuildContext context) {
    dismissAppLoadingDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          _showAuthLoadingDialog(context);
        } else {
          _dismissAuthLoadingDialog(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            widget.navigationShell,
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    left: 20,
                    right: 20,
                  ),
                  child: AppBottomNavigationBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
