import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/notifications/domain/models/pending_notification_entity.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_all_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/get_pending_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/reconcile_task_reminders_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/schedule_test_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/show_instant_test_notification_use_case.dart';

part 'debug_event.dart';
part 'debug_state.dart';

class DebugBloc extends Bloc<DebugEvent, DebugState> {
  DebugBloc({
    required GetPendingNotificationsUseCase getPendingNotificationsUseCase,
    required ShowInstantTestNotificationUseCase
    showInstantTestNotificationUseCase,
    required ScheduleTestNotificationUseCase scheduleTestNotificationUseCase,
    required CancelNotificationUseCase cancelNotificationUseCase,
    required CancelAllNotificationsUseCase cancelAllNotificationsUseCase,
    required ReconcileTaskRemindersUseCase reconcileTaskRemindersUseCase,
  }) : _getPendingNotificationsUseCase = getPendingNotificationsUseCase,
       _showInstantTestNotificationUseCase = showInstantTestNotificationUseCase,
       _scheduleTestNotificationUseCase = scheduleTestNotificationUseCase,
       _cancelNotificationUseCase = cancelNotificationUseCase,
       _cancelAllNotificationsUseCase = cancelAllNotificationsUseCase,
       _reconcileTaskRemindersUseCase = reconcileTaskRemindersUseCase,
       super(const DebugState()) {
    on<DebugStarted>(_onStarted);
    on<DebugPendingRequested>(_onPendingRequested);
    on<DebugShowInstantNotificationRequested>(_onShowInstantRequested);
    on<DebugScheduleNotificationRequested>(_onScheduleRequested);
    on<DebugNotificationCancelRequested>(_onCancelNotificationRequested);
    on<DebugNotificationsCancelAllRequested>(_onCancelAllRequested);
    on<DebugReconcileRemindersRequested>(_onReconcileRequested);
  }

  final GetPendingNotificationsUseCase _getPendingNotificationsUseCase;
  final ShowInstantTestNotificationUseCase _showInstantTestNotificationUseCase;
  final ScheduleTestNotificationUseCase _scheduleTestNotificationUseCase;
  final CancelNotificationUseCase _cancelNotificationUseCase;
  final CancelAllNotificationsUseCase _cancelAllNotificationsUseCase;
  final ReconcileTaskRemindersUseCase _reconcileTaskRemindersUseCase;

  Future<void> _onStarted(DebugStarted event, Emitter<DebugState> emit) async {
    add(const DebugPendingRequested());
  }

  Future<void> _onPendingRequested(
    DebugPendingRequested event,
    Emitter<DebugState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingPending: true,
        clearFeedbackMessage: true,
        isErrorFeedback: false,
      ),
    );

    try {
      final pending = await _getPendingNotificationsUseCase();
      emit(
        state.copyWith(pendingNotifications: pending, isLoadingPending: false),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingPending: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Failed to load pending notifications',
          isErrorFeedback: true,
        ),
      );
    }
  }

  Future<void> _onShowInstantRequested(
    DebugShowInstantNotificationRequested event,
    Emitter<DebugState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await _showInstantTestNotificationUseCase(
        title: event.title,
        body: event.body,
      );
      final pending = await _getPendingNotificationsUseCase();

      emit(
        state.copyWith(
          pendingNotifications: pending,
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Notification shown immediately',
          isErrorFeedback: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Failed to show notification',
          isErrorFeedback: true,
        ),
      );
    }
  }

  Future<void> _onScheduleRequested(
    DebugScheduleNotificationRequested event,
    Emitter<DebugState> emit,
  ) async {
    if (event.delaySeconds <= 0) {
      emit(
        state.copyWith(
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Delay must be more than 0 seconds',
          isErrorFeedback: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      await _scheduleTestNotificationUseCase(
        title: event.title,
        body: event.body,
        delay: Duration(seconds: event.delaySeconds),
      );
      final pending = await _getPendingNotificationsUseCase();

      emit(
        state.copyWith(
          pendingNotifications: pending,
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage:
              'Scheduled test notification in ${event.delaySeconds} seconds',
          isErrorFeedback: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Failed to schedule notification',
          isErrorFeedback: true,
        ),
      );
    }
  }

  Future<void> _onCancelNotificationRequested(
    DebugNotificationCancelRequested event,
    Emitter<DebugState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await _cancelNotificationUseCase(event.notificationId);
      final pending = await _getPendingNotificationsUseCase();

      emit(
        state.copyWith(
          pendingNotifications: pending,
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Cancelled notification ${event.notificationId}',
          isErrorFeedback: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage:
              'Failed to cancel notification ${event.notificationId}',
          isErrorFeedback: true,
        ),
      );
    }
  }

  Future<void> _onCancelAllRequested(
    DebugNotificationsCancelAllRequested event,
    Emitter<DebugState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await _cancelAllNotificationsUseCase();

      emit(
        state.copyWith(
          pendingNotifications: const [],
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Cancelled all notifications',
          isErrorFeedback: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Failed to cancel all notifications',
          isErrorFeedback: true,
        ),
      );
    }
  }

  Future<void> _onReconcileRequested(
    DebugReconcileRemindersRequested event,
    Emitter<DebugState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await _reconcileTaskRemindersUseCase();
      final pending = await _getPendingNotificationsUseCase();

      emit(
        state.copyWith(
          pendingNotifications: pending,
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Task reminders reconciled',
          isErrorFeedback: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: 'Failed to reconcile task reminders',
          isErrorFeedback: true,
        ),
      );
    }
  }
}
