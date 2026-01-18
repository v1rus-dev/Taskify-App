import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/home/presentation/providers/home_screen_notifier.dart';
import 'package:taskify/features/home/presentation/widgets/add_task_button.dart';
import 'package:taskify/features/home/presentation/widgets/home_app_bar.dart';
import 'package:taskify/features/home/presentation/widgets/home_hided_header.dart';
import 'package:taskify/features/home/presentation/widgets/taks_card.dart';
import 'package:taskify/domain/entities/task.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _onAddTask() {
    appRouter.push(RouterPaths.editTask);
  }

  void _onTaskClicked(TaskEntity task) {
    appRouter.push(RouterPaths.editTask, extra: task.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeScreenNotifierProvider);
    final notifier = ref.read(homeScreenNotifierProvider.notifier);

    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: AddTaskButton(onPressed: _onAddTask),
      body: CustomScrollView(
        slivers: [
          const SliverGap(32.0),
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              ),
              child: state.isHeaderExpanded
                  ? const HomeHidedHeader(key: ValueKey('header'))
                  : const SizedBox(key: ValueKey('empty')),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) => TaskCard(
                task: state.tasks[index],
                onTaskClicked: () => _onTaskClicked(state.tasks[index]),
                onCheckboxPressed: () =>
                    notifier.updateTaskCompletion(state.tasks[index]),
              ),
              itemCount: state.tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}
