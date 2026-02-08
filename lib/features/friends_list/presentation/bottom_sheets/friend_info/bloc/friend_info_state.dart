part of 'friend_info_bloc.dart';

sealed class FriendInfoState extends Equatable {
  const FriendInfoState();

  @override
  List<Object?> get props => [];
}

final class FriendInfoLoading extends FriendInfoState {
  const FriendInfoLoading();
}

final class FriendInfoSuccess extends FriendInfoState {
  const FriendInfoSuccess({
    required this.friend,
    required this.isFriend,
    this.isRemoving = false,
    this.removeErrorMessage,
  });

  final FriendModelUi friend;
  final bool isFriend;
  final bool isRemoving;
  final String? removeErrorMessage;

  FriendInfoSuccess copyWith({
    FriendModelUi? friend,
    bool? isFriend,
    bool? isRemoving,
    String? removeErrorMessage,
    bool clearRemoveErrorMessage = false,
  }) {
    return FriendInfoSuccess(
      friend: friend ?? this.friend,
      isFriend: isFriend ?? this.isFriend,
      isRemoving: isRemoving ?? this.isRemoving,
      removeErrorMessage: clearRemoveErrorMessage
          ? null
          : removeErrorMessage ?? this.removeErrorMessage,
    );
  }

  @override
  List<Object?> get props => [friend, isFriend, isRemoving, removeErrorMessage];
}

final class FriendInfoError extends FriendInfoState {
  const FriendInfoError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
