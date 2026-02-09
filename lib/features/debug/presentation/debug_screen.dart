import 'package:design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/features/debug/presentation/bloc/debug_bloc.dart';

class DebugScreenPage extends StatelessWidget {
  const DebugScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebugBloc(),
      child: const DebugScreen(),
    );
  }
}

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  void _onBackPressed(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: 'Debug', onBack: () => _onBackPressed(context)),
      body: BlocBuilder<DebugBloc, DebugState>(
      builder: (context, state) {
        return const Center(child: Text('Debug Screen'));
      },
    ));
  }
}