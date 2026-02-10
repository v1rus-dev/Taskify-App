import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/spaces/presentation/bloc/spaces_bloc.dart';
import 'package:taskify/features/spaces/presentation/widgets/create_space_bottom_sheet.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SpacesScreenPage extends StatelessWidget {
  const SpacesScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpacesBloc()..add(const SpacesStarted()),
      child: const SpacesScreen(),
    );
  }
}

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<SpacesBloc>().add(const SpacesRefreshed());
  }

  Future<void> _onCreatePressed(BuildContext context) async {
    final result = await showAppBottomSheet<CreateSpaceResult>(
      context: context,
      type: AppBottomSheetType.floating,
      child: const CreateSpaceBottomSheetPage(),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.read<SpacesBloc>().add(
      SpacesCreateRequested(name: result.name, description: result.description),
    );
  }

  void _openSpace(BuildContext context, SpaceEntity space) {
    appRouter.push('${RouterPaths.spaceDetails}/${space.id}', extra: space);
  }

  Widget _buildSpaceTile(BuildContext context, SpaceEntity space) {
    return Card(
      child: ListTile(
        onTap: () => _openSpace(context, space),
        title: Text(space.name),
        subtitle: Text(
          [
            if (space.description != null && space.description!.isNotEmpty)
              space.description!,
            space.role.value,
            if (space.isLightweight) 'lightweight',
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: AppLocalizations.of(context)?.spaces ?? ''),
      body: BlocBuilder<SpacesBloc, SpacesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (state.errorMessage != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: AppColorExtensions.getErrorColor(context),
                        ),
                      ),
                    ),
                  ),
                if (state.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No spaces yet')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) =>
                          _buildSpaceTile(context, state.spaces[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: state.spaces.length,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 56 + 16 + MediaQuery.of(context).padding.bottom),
        child: FloatingActionButton.extended(
          onPressed: () => _onCreatePressed(context),
          label: const Text('Create'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
