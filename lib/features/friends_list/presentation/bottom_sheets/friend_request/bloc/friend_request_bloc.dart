import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_request_model_ui.dart';

part 'friend_request_event.dart';
part 'friend_request_state.dart';
part 'friend_request_side_effect.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState>
    with BlocSideEffectMixin<FriendRequestBloc, FriendRequestSideEffect> {
  final FriendRequestModelUi request;
  final FriendsInteractor _interactor = locator<FriendsInteractor>();

  final _sideEffectController = StreamController<FriendRequestSideEffect>();
  
  @override
  Stream<FriendRequestSideEffect> get sideEffects => _sideEffectController.stream;

  FriendRequestBloc({required this.request})
    : super(FriendRequestState(request: request)) {
    on<FriendRequestCancelEvent>(_onCancel);
    on<FriendRequestAcceptEvent>(_onAccept);
    on<FriendRequestRejectEvent>(_onReject);
  }

  Future<void> _onCancel(
    FriendRequestCancelEvent event,
    Emitter<FriendRequestState> emit,
  ) async {
    final result = await _interactor.cancelRequest(request.requestId);
    result.fold(
      ifLeft: (_) {},
      ifRight: (_) {
        TalkerService.instance.info(
          'Friend request cancelled: ${request.user.name}',
        );
        _sideEffectController.add(const FriendRequestCloseBottomSheet());
      },
    );
  }

  Future<void> _onAccept(
    FriendRequestAcceptEvent event,
    Emitter<FriendRequestState> emit,
  ) async {
    final result = await _interactor.acceptRequest(request.requestId);
    result.fold(
      ifLeft: (_) {},
      ifRight: (friend) {
        TalkerService.instance.info('Friend accepted: ${friend.name}');
        _sideEffectController.add(const FriendRequestCloseBottomSheet());
      },
    );
  }

  Future<void> _onReject(
    FriendRequestRejectEvent event,
    Emitter<FriendRequestState> emit,
  ) async {
    final result = await _interactor.declineRequest(request.requestId);
    result.fold(
      ifLeft: (_) {},
      ifRight: (_) {
        TalkerService.instance.info('Friend rejected: ${request.user.name}');
        _sideEffectController.add(const FriendRequestCloseBottomSheet());
      },
    );
  }

  @override
  Future<void> close() {
    _sideEffectController.close();
    return super.close();
  }
}
