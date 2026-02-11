import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class DayStreakCard extends StatelessWidget {
  const DayStreakCard({super.key, required this.streakInfo});

  final StreakInfo streakInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      height: 120,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n?.activeDayStreak ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColorExtensions.getTextPrimaryColor(context),
                    ),
                  ),
                  Text(
                    l10n?.days(context, streakInfo.currentStreak) ?? '',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColorExtensions.getTextPrimaryColor(context),
                    ),
                  ),
                ],
              ),
              Text(
                l10n?.completeTasksToStartOne ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
  }
}
