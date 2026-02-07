import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_request_model_ui.dart';

part 'friends_list_event.dart';
part 'friends_list_state.dart';

class FriendsListBloc extends Bloc<FriendsListEvent, FriendsListState> {
  FriendsListBloc() : super(const FriendsListState()) {
    on<FriendsListStarted>(_onStarted);
    on<TryAddFriend>(_onTryAddFriend);
    on<UpdateFriendsList>(_onUpdateFriendsList);
    on<UpdateIncomingRequests>(_onUpdateIncomingRequests);
    on<UpdateOutgoingRequests>(_onUpdateOutgoingRequests);
  }

  final FriendsInteractor _interactor = locator<FriendsInteractor>();
  StreamSubscription? _friendsSubscription;
  StreamSubscription? _incomingRequestsSubscription;
  StreamSubscription? _outgoingRequestsSubscription;

  Future<void> _onStarted(
    FriendsListStarted event,
    Emitter<FriendsListState> emit,
  ) async {
    _friendsSubscription ??= _interactor.observeFriends().listen((friends) {
      add(
        UpdateFriendsList(friends.map((friend) => friend.toUiModel()).toList()),
      );
    });
    _incomingRequestsSubscription ??= _interactor
        .observeIncomingRequests()
        .listen((requests) {
          add(
            UpdateIncomingRequests(
              requests.map((request) => request.toUiModel()).toList(),
            ),
          );
        });
    _outgoingRequestsSubscription ??= _interactor
        .observeOutgoingRequests()
        .listen((requests) {
          add(
            UpdateOutgoingRequests(
              requests.map((request) => request.toUiModel()).toList(),
            ),
          );
        });
  }

  Future<void> refreshData() async {
    final futures = <Future<void>>[
      _interactor.getFriends().then(
        (result) => result.fold(
          ifLeft: (failure) {
            TalkerService.instance.error(
              'friendsList getFriends failed',
              failure,
            );
          },
          ifRight: (_) {},
        ),
      ),
      _interactor.getFriendRequests().then(
        (result) => result.fold(
          ifLeft: (failure) {
            TalkerService.instance.error(
              'friendsList getFriendRequests failed',
              failure,
            );
          },
          ifRight: (_) {},
        ),
      ),
    ];
    await Future.wait(futures);
  }

  Future<void> _onUpdateFriendsList(
    UpdateFriendsList event,
    Emitter<FriendsListState> emit,
  ) async {
    emit(state.copyWith(friends: event.friends));
  }

  Future<void> _onUpdateIncomingRequests(
    UpdateIncomingRequests event,
    Emitter<FriendsListState> emit,
  ) async {
    emit(state.copyWith(incomingRequests: event.requests));
  }

  Future<void> _onUpdateOutgoingRequests(
    UpdateOutgoingRequests event,
    Emitter<FriendsListState> emit,
  ) async {
    emit(state.copyWith(outgoingRequests: event.requests));
  }

  Future<void> _onTryAddFriend(
    TryAddFriend event,
    Emitter<FriendsListState> emit,
  ) async {
    TalkerService.instance.info(
      'Sending friend request to ${event.friendCode}',
    );
    final result = await _interactor.sendFriendRequest(event.friendCode);
    result.fold(
      ifLeft: (_) {},
      ifRight: (_) {
        TalkerService.instance.info('Friend request sent');
      },
    );
  }

  @override
  Future<void> close() async {
    await _friendsSubscription?.cancel();
    await _incomingRequestsSubscription?.cancel();
    await _outgoingRequestsSubscription?.cancel();
    return super.close();
  }
}
