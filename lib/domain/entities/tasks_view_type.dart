import 'package:taskify/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum TasksViewType {
  tasks,
  timeline,
}

extension TaskViewTypeExtensions on TasksViewType {
  String getTitle(BuildContext context) => switch (this) {
    TasksViewType.tasks => AppLocalizations.of(context)?.tasks ?? '',
    TasksViewType.timeline => AppLocalizations.of(context)?.timeline ?? '',
  };
}