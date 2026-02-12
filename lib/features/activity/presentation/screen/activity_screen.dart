import 'package:flutter/material.dart';
import 'package:design/widgets/screen_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:taskify/features/activity/presentation/widgets/day_streak_card.dart';
import 'package:taskify/features/activity/presentation/widgets/most_used_tags_card.dart';
import 'package:taskify/features/activity/presentation/widgets/stats_card.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AcitivityScreenPage extends StatelessWidget {
  const AcitivityScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivityScreen();
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
                sliver: StatsCard(heatmapCells: state.stats.heatmapCells),
              ),
              const SliverGap(12),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: DayStreakCard(streakInfo: state.streak),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MostUsedTagsCard(tagsInfo: state.tags),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
