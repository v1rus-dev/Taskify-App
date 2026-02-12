import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/friends/domain/usecases/friends_interactor.dart';
import 'package:taskify/features/friends/presentation/friends_list/models/friend_model_ui.dart';

part 'friend_info_event.dart';
part 'friend_info_state.dart';

class FriendInfoBloc extends Bloc<FriendInfoEvent, FriendInfoState> {
  final FriendsInteractor _interactor = locator<FriendsInteractor>();

  final String friendId;

  FriendInfoBloc({required this.friendId}) : super(FriendInfoLoading()) {
    on<FriendInfoStarted>(_onStarted);
    on<FriendInfoRemovePressed>(_onRemovePressed);
  }

  Future<void> _onStarted(
    FriendInfoStarted event,
    Emitter<FriendInfoState> emit,
  ) async {
    final result = await _interactor.getFriendInfo(friendId);
    result.fold(
      ifLeft: (failure) {
        emit(FriendInfoError(message: failure.message));
      },
      ifRight: (friendProfile) {
        emit(
          FriendInfoSuccess(
            friend: friendProfile.friend.toUiModel(),
            isFriend: friendProfile.isFriend,
          ),
        );
      },
    );
  }

  Future<void> _onRemovePressed(
    FriendInfoRemovePressed event,
    Emitter<FriendInfoState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FriendInfoSuccess) {
      return;
    }
    if (!currentState.isFriend || currentState.isRemoving) {
      return;
    }

    emit(
      currentState.copyWith(isRemoving: true, clearRemoveErrorMessage: true),
    );

    final result = await _interactor.removeFriend(currentState.friend.id);
    result.fold(
      ifLeft: (failure) {
        TalkerService.instance.error(
          'Failed to remove friend: ${failure.message}',
        );
        emit(
          currentState.copyWith(
            isRemoving: false,
            removeErrorMessage: failure.message,
          ),
        );
      },
      ifRight: (_) {
        TalkerService.instance.info(
          'Friend removed from profile bottom sheet: ${currentState.friend.id}',
        );
        emit(
          currentState.copyWith(
            isFriend: false,
            isRemoving: false,
            clearRemoveErrorMessage: true,
          ),
        );
      },
    );
  }
}
