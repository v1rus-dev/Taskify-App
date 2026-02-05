import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';

part 'friends_list_event.dart';
part 'friends_list_state.dart';

class FriendsListBloc extends Bloc<FriendsListEvent, FriendsListState> {
  FriendsListBloc() : super(const FriendsListState()) {
    on<FriendsListStarted>(_onStarted);
  }

  final FriendsInteractor _interactor = locator<FriendsInteractor>();

  Future<void> _onStarted(
    FriendsListStarted event,
    Emitter<FriendsListState> emit,
  ) async {
    final result = await _interactor.getFriends();
    result.fold(
      ifLeft: (_) {},
      ifRight: (friends) => emit(
        state.copyWith(
          friends: friends.map((friend) => friend.toUiModel()).toList(),
        ),
      ),
    );
  }
}
