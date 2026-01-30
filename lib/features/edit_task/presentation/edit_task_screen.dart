import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_app_bar.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_description_card.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_date_period_card.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_sub_tasks_slivers.dart';
import 'package:taskify/features/edit_task/presentation/widgets/edit_task_tags_card.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_sub_task/edit_sub_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key, required this.taskId});
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditTaskBloc(
            taskId: taskId,
            taskInteractor: locator<TaskInteractor>(),
            subTaskInteractor: locator<SubTaskInteractor>(),
            tagInteractor: locator<TagInteractor>(),
          )..add(const EditTaskEvent.started()),
        ),
        BlocProvider(
          create: (context) => EditSubTaskBloc(
            taskId: taskId,
            subTaskInteractor: locator<SubTaskInteractor>(),
          )..add(const EditSubTaskEvent.started()),
        ),
      ],
      child: EditTaskScreen(taskId: taskId),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, this.taskId});
  final int? taskId;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final titleController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Widget _buildTitleTextField() {
    final theme = Theme.of(context);
    return TextField(
      controller: titleController,
      maxLines: null,
      maxLength: 155,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColorExtensions.getTextPrimaryColor(context),
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)?.writeANewTask ?? '',
        border: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        counterText: '',
        hintStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColorExtensions.getTextSecondaryColor(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<EditTaskBloc, EditTaskSideEffect>(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColorExtensions.getBackgroundColor(context),
        appBar: EditTaskAppBar(taskId: widget.taskId),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverGap(20),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: _buildTitleTextField()),
            ),
            const SliverGap(12),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: EditTaskDescriptionCard()),
            ),
            const SliverGap(12),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: EditTaskDatePeriodCard()),
            ),
            const SliverGap(12),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: EditTaskTagsCard()),
            ),
            const SliverGap(12),
            const EditTaskSubTasksSlivers(),
            const SliverGap(12),
          ],
        ),
      ),
    );
  }
}
