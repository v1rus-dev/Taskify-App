part of 'activity_bloc.dart';

sealed class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

final class ActivityStarted extends ActivityEvent {
  const ActivityStarted();
}

final class ActivityCompletedMapReceived extends ActivityEvent {
  const ActivityCompletedMapReceived(this.completedByDate);

  final Map<DateTime, int> completedByDate;

  @override
  List<Object?> get props => [completedByDate];
}

final class ActivityTopTagsReceived extends ActivityEvent {
  const ActivityTopTagsReceived(this.topTags);

  final List<ActivityTopTag> topTags;

  @override
  List<Object?> get props => [topTags];
}
