part of 'debug_bloc.dart';

sealed class DebugEvent extends Equatable {
  const DebugEvent();

  @override
  List<Object?> get props => [];
}

final class DebugStarted extends DebugEvent {
  const DebugStarted();
}

final class DebugPendingRequested extends DebugEvent {
  const DebugPendingRequested();
}

final class DebugShowInstantNotificationRequested extends DebugEvent {
  const DebugShowInstantNotificationRequested({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  List<Object?> get props => [title, body];
}

final class DebugScheduleNotificationRequested extends DebugEvent {
  const DebugScheduleNotificationRequested({
    required this.title,
    required this.body,
    required this.delaySeconds,
  });

  final String title;
  final String body;
  final int delaySeconds;

  @override
  List<Object?> get props => [title, body, delaySeconds];
}

final class DebugNotificationCancelRequested extends DebugEvent {
  const DebugNotificationCancelRequested(this.notificationId);

  final int notificationId;

  @override
  List<Object?> get props => [notificationId];
}

final class DebugNotificationsCancelAllRequested extends DebugEvent {
  const DebugNotificationsCancelAllRequested();
}

final class DebugReconcileRemindersRequested extends DebugEvent {
  const DebugReconcileRemindersRequested();
}
