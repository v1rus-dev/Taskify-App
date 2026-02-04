import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:taskify/domain/tasks/models/task_wrapper.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/task_info_bottom_sheet.dart';
import 'package:taskify/features/home/presentation/widgets/home_app_bar.dart';
import 'package:taskify/features/home/presentation/widgets/home_hided_header.dart';
import 'package:taskify/features/home/presentation/widgets/task_card.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        taskInteractor: locator<TaskInteractor>(),
        syncCoordinator: locator<SyncCoordinator>(),
      )..add(const HomeStarted()),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  final Duration _animationDuration = const Duration(milliseconds: 360);
  static const double _insertSlideOffset = 0.08;
  static const double _removeSlideOffset = 0.05;

  void _onTaskClicked(BuildContext context, TaskWrapperEntity task) {
    if (task.task.id == null) return;
    showAppBottomSheet(
      context: context,
      type: AppBottomSheetType.floating,
      showDragHandle: false,
      barrierColor: Colors.white,
      child: TaskInfoBottomSheet(taskId: task.task.id!),
    );
  }

  void _onTaskCheckboxPressed(BuildContext context, TaskWrapperEntity task) {
    context.read<HomeBloc>().add(HomeUpdateTaskCompletion(task));
  }

  Widget _buildAnimatedTaskItem({
    required BuildContext context,
    required Animation<double> animation,
    required TaskWrapperEntity item,
    required bool isRemoving,
  }) {
    final curve = isRemoving ? Curves.easeInCubic : Curves.easeOutCubic;
    final slide = Tween<Offset>(
      begin: isRemoving ? Offset.zero : const Offset(0, _insertSlideOffset),
      end: isRemoving ? const Offset(0, -_removeSlideOffset) : Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    return SlideTransition(
      position: slide,
      child: SizeFadeTransition(
        sizeFraction: 0.78,
        curve: curve,
        animation: animation,
        child: Column(
          children: [
            TaskCard(
              key: ValueKey(item.task.id),
              task: item,
              onTaskClicked: () => _onTaskClicked(context, item),
              onCheckboxPressed: () => _onTaskCheckboxPressed(context, item),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: CustomScrollView(
              slivers: [
                const SliverGap(8),
                SliverAnimatedSwitcher(
                  duration: _animationDuration,
                  reverseDuration: _animationDuration,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: state.isHeaderExpanded
                      ? const SliverToBoxAdapter(
                          key: ValueKey('header'),
                          child: HomeHidedHeader(),
                        )
                      : const SliverToBoxAdapter(
                          key: ValueKey('empty'),
                          child: SizedBox.shrink(),
                        ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom:
                        24 + 76 + 16 + MediaQuery.of(context).padding.bottom,
                  ),
                  sliver: SliverImplicitlyAnimatedList<TaskWrapperEntity>(
                    items: state.tasks,
                    insertDuration: _animationDuration,
                    removeDuration: _animationDuration,
                    itemBuilder: (context, animation, item, index) {
                      return _buildAnimatedTaskItem(
                        context: context,
                        animation: animation,
                        item: item,
                        isRemoving: false,
                      );
                    },
                    removeItemBuilder: (context, animation, item) {
                      return _buildAnimatedTaskItem(
                        context: context,
                        animation: animation,
                        item: item,
                        isRemoving: true,
                      );
                    },
                    areItemsTheSame: (a, b) => a.task.id == b.task.id,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
