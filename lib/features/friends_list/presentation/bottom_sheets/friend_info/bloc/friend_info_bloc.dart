import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';

part 'friend_info_event.dart';
part 'friend_info_state.dart';

class FriendInfoBloc extends Bloc<FriendInfoEvent, FriendInfoState> {
  final FriendsInteractor _interactor = locator<FriendsInteractor>();

  final String friendId;

  FriendInfoBloc({required this.friendId}) : super(FriendInfoLoading()) {
    on<FriendInfoStarted>(_onStarted);
  }

  void _onStarted(
    FriendInfoStarted event,
    Emitter<FriendInfoState> emit,
  ) async {
    // final friend = await _interactor.getFriendById(friendId);
    // emit(FriendInfoSuccess(friend: friend));
  }
}
