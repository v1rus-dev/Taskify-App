import 'package:flutter/material.dart';
import 'package:design/widgets/screen_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/activity/domain/usecases/activity_interactor.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AcitivityScreenPage extends StatelessWidget {
  const AcitivityScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActivityBloc(activityInteractor: locator<ActivityInteractor>())
            ..add(const ActivityStarted()),
      child: const ActivityScreen(),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: AppLocalizations.of(context)?.activity ?? ''),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(child: Text('Activity')),
              ),
            ],
          );
        },
      ),
    );
  }
}
