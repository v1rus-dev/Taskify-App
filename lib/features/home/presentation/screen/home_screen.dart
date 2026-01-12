import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/home/presentation/screen/home_screen_notifier.dart';
import 'package:taskify/features/home/presentation/widgets/add_task_button.dart';
import 'package:taskify/features/home/presentation/widgets/home_app_bar.dart';
import 'package:taskify/features/home/presentation/widgets/home_hided_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  _onAddTask() {
    appRouter.push(RouterPaths.editTask);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeScreenNotifierProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: AddTaskButton(onPressed: _onAddTask),
      body: CustomScrollView(
        slivers: [
         const SliverGap(32.0),
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                ),
              ),
              child: state.isHeaderExpanded
                  ? const HomeHidedHeader(key: ValueKey('HeaderVisible'))
                  : const SizedBox(key: ValueKey('HeaderHidden')),
            ),
          ),
        ],
      ),
    );
  }
}
