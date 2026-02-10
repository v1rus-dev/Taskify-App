import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';
import 'package:taskify/features/spaces/presentation/bloc/space_details_bloc.dart';
import 'package:taskify/features/spaces/presentation/widgets/single_input_bottom_sheet.dart';

class SpaceDetailsPage extends StatelessWidget {
  const SpaceDetailsPage({super.key, required this.space});

  final SpaceEntity space;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SpaceDetailsBloc(space: space)..add(const SpaceDetailsStarted()),
      child: const SpaceDetailsScreen(),
    );
  }
}

class SpaceDetailsScreen extends StatelessWidget {
  const SpaceDetailsScreen({super.key});

  void _onBackPressed() {
    appRouter.pop();
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<SpaceDetailsBloc>().add(const SpaceDetailsRefreshed());
  }

  Future<void> _addList(BuildContext context) async {
    final result = await showAppBottomSheet<SingleInputResult>(
      context: context,
      type: AppBottomSheetType.floating,
      child: const SingleInputBottomSheetPage(
        title: 'Create list',
        label: 'List title',
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.read<SpaceDetailsBloc>().add(SpaceListCreated(title: result.title));
  }

  Future<void> _addTask(BuildContext context) async {
    final result = await showAppBottomSheet<SingleInputResult>(
      context: context,
      type: AppBottomSheetType.floating,
      child: const SingleInputBottomSheetPage(
        title: 'Create task',
        label: 'Task title',
        descriptionLabel: 'Description',
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.read<SpaceDetailsBloc>().add(
      SpaceTaskCreated(title: result.title, description: result.description),
    );
  }

  Future<void> _addNote(BuildContext context) async {
    final result = await showAppBottomSheet<SingleInputResult>(
      context: context,
      type: AppBottomSheetType.floating,
      child: const SingleInputBottomSheetPage(
        title: 'Create note',
        label: 'Note title',
        descriptionLabel: 'Body',
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.read<SpaceDetailsBloc>().add(
      SpaceNoteCreated(title: result.title, body: result.description),
    );
  }

  Future<void> _addMember(BuildContext context) async {
    final result = await showAppBottomSheet<SingleInputResult>(
      context: context,
      type: AppBottomSheetType.floating,
      child: const SingleInputBottomSheetPage(
        title: 'Add member',
        label: 'User id',
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.read<SpaceDetailsBloc>().add(
      SpaceMemberAdded(userId: result.title, role: SpaceRole.editor),
    );
  }

  void _createInvite(BuildContext context) {
    context.read<SpaceDetailsBloc>().add(
      const SpaceInviteCreated(role: SpaceRole.viewer),
    );
  }

  Widget _buildTasksTab(SpaceDetailsState state) {
    if (state.tasks.isEmpty) {
      return const Center(child: Text('No tasks'));
    }
    return ListView.builder(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(
            [
              if (task.listId != null) 'list ${task.listId}',
              task.isCompleted ? 'completed' : 'open',
              if (task.assigneeId != null) 'assignee ${task.assigneeId}',
            ].join(' · '),
          ),
        );
      },
    );
  }

  Widget _buildListsTab(SpaceDetailsState state) {
    if (state.lists.isEmpty) {
      return const Center(child: Text('No lists'));
    }
    return ListView.builder(
      itemCount: state.lists.length,
      itemBuilder: (context, index) {
        final list = state.lists[index];
        return ListTile(
          title: Text(list.title),
          subtitle: Text('order ${list.order}'),
        );
      },
    );
  }

  Widget _buildNotesTab(SpaceDetailsState state) {
    if (state.notes.isEmpty) {
      return const Center(child: Text('No notes'));
    }
    return ListView.builder(
      itemCount: state.notes.length,
      itemBuilder: (context, index) {
        final note = state.notes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.body ?? ''),
        );
      },
    );
  }

  Widget _buildMembersTab(SpaceDetailsState state) {
    if (state.members.isEmpty) {
      return const Center(child: Text('No members'));
    }
    return ListView.builder(
      itemCount: state.members.length,
      itemBuilder: (context, index) {
        final member = state.members[index];
        return ListTile(
          title: Text(member.name ?? member.userId),
          subtitle: Text(member.role.value),
        );
      },
    );
  }

  Widget _buildInvitesTab(SpaceDetailsState state) {
    if (state.invites.isEmpty) {
      return const Center(child: Text('No invites'));
    }
    return ListView.builder(
      itemCount: state.invites.length,
      itemBuilder: (context, index) {
        final invite = state.invites[index];
        return ListTile(
          title: Text(invite.token ?? invite.id),
          subtitle: Text(
            [
              invite.role.value,
              if (invite.expiresAt != null) invite.expiresAt.toString(),
              if (invite.isRevoked) 'revoked',
            ].join(' · '),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceDetailsBloc, SpaceDetailsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.space.name),
              leading: IconButton(
                onPressed: _onBackPressed,
                icon: const Icon(Icons.arrow_back),
              ),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Tasks'),
                  Tab(text: 'Lists'),
                  Tab(text: 'Notes'),
                  Tab(text: 'Members'),
                  Tab(text: 'Invites'),
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: Column(
                children: [
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: AppColorExtensions.getErrorColor(context),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTasksTab(state),
                        _buildListsTab(state),
                        _buildNotesTab(state),
                        _buildMembersTab(state),
                        _buildInvitesTab(state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () => _addTask(context),
                    child: const Text('Add task'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _addList(context),
                    child: const Text('Add list'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _addNote(context),
                    child: const Text('Add note'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _addMember(context),
                    child: const Text('Add member'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _createInvite(context),
                    child: const Text('Create invite'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
