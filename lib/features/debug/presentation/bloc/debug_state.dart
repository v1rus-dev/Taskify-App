part of 'debug_bloc.dart';

final class DebugState extends Equatable {
  const DebugState({
    this.pendingNotifications = const [],
    this.isLoadingPending = false,
    this.isSubmitting = false,
    this.feedbackId = 0,
    this.feedbackMessage,
    this.isErrorFeedback = false,
  });

  final List<PendingNotificationEntity> pendingNotifications;
  final bool isLoadingPending;
  final bool isSubmitting;
  final int feedbackId;
  final String? feedbackMessage;
  final bool isErrorFeedback;

  DebugState copyWith({
    List<PendingNotificationEntity>? pendingNotifications,
    bool? isLoadingPending,
    bool? isSubmitting,
    int? feedbackId,
    String? feedbackMessage,
    bool? isErrorFeedback,
    bool clearFeedbackMessage = false,
  }) {
    return DebugState(
      pendingNotifications: pendingNotifications ?? this.pendingNotifications,
      isLoadingPending: isLoadingPending ?? this.isLoadingPending,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      feedbackId: feedbackId ?? this.feedbackId,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      isErrorFeedback: isErrorFeedback ?? this.isErrorFeedback,
    );
  }

  @override
  List<Object?> get props => [
    pendingNotifications,
    isLoadingPending,
    isSubmitting,
    feedbackId,
    feedbackMessage,
    isErrorFeedback,
  ];
}
