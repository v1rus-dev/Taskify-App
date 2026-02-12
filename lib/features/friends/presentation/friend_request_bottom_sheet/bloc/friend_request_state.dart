part of 'friend_request_bloc.dart';

class FriendRequestState extends Equatable {
  const FriendRequestState({required this.request});

  final FriendRequestModelUi request;

  FriendRequestState copyWith({FriendRequestModelUi? request}) {
    return FriendRequestState(request: request ?? this.request);
  }

  @override
  List<Object?> get props => [request];
}
