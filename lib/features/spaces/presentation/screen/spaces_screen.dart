import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/spaces/presentation/bloc/spaces_bloc.dart';
import 'package:design/widgets/screen_app_bar.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SpacesScreenPage extends StatelessWidget {
  const SpacesScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpacesBloc(),
      child: const SpacesScreen(),
    );
  }
}

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: AppLocalizations.of(context)?.spaces ?? ''),
      body: BlocBuilder<SpacesBloc, SpacesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(child: Text('Spaces')),
              ),
            ],
          );
        },
      ),
    );
  }
}
