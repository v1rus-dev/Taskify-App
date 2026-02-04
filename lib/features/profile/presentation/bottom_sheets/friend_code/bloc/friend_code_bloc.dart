import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';
import 'package:taskify/features/profile/domain/usecases/update_friend_code_interactor.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:equatable/equatable.dart';

part 'friend_code_event.dart';
part 'friend_code_state.dart';

class FriendCodeBloc extends Bloc<FriendCodeEvent, FriendCodeState> {
  FriendCodeBloc({
    ProfileRepository? profileRepository,
    UpdateFriendCodeInteractor? updateFriendCodeInteractor,
  })  : _profileRepository =
            profileRepository ?? locator<ProfileRepository>(),
        _updateFriendCodeInteractor =
            updateFriendCodeInteractor ??
                locator<UpdateFriendCodeInteractor>(),
        super(const FriendCodeInitial()) {
    on<FriendCodeStarted>(_onStarted);
    on<FriendCodeProfileUpdated>(_onProfileUpdated);
    on<FriendCodeProfileFailed>(_onProfileFailed);
    on<FriendCodeGeneratePressed>(_onGeneratePressed);
  }

  final ProfileRepository _profileRepository;
  final UpdateFriendCodeInteractor _updateFriendCodeInteractor;

  StreamSubscription? _profileSubscription;
  String _latestFriendCode = '';
  bool _isGenerating = false;

  Future<void> _onStarted(
    FriendCodeStarted event,
    Emitter<FriendCodeState> emit,
  ) async {
    _observeProfile();
  }

  void _onProfileUpdated(
    FriendCodeProfileUpdated event,
    Emitter<FriendCodeState> emit,
  ) {
    _latestFriendCode = event.friendCode;
    if (_isGenerating) {
      return;
    }
    emit(FriendCodeSuccess(friendCode: event.friendCode));
  }

  void _onProfileFailed(
    FriendCodeProfileFailed event,
    Emitter<FriendCodeState> emit,
  ) {
    if (_isGenerating) {
      return;
    }
    emit(
      FriendCodeError(
        friendCode: _latestFriendCode,
        failure: event.failure,
      ),
    );
  }

  Future<void> _onGeneratePressed(
    FriendCodeGeneratePressed event,
    Emitter<FriendCodeState> emit,
  ) async {
    if (_isGenerating) {
      return;
    }
    _isGenerating = true;
    emit(FriendCodeLoading(friendCode: _latestFriendCode));

    final result = await _updateFriendCodeInteractor();
    Failure? failure;
    String? friendCode;
    result.fold(
      ifLeft: (left) => failure = left,
      ifRight: (user) => friendCode = user.friendTag,
    );

    _isGenerating = false;
    if (failure != null) {
      emit(
        FriendCodeError(
          friendCode: _latestFriendCode,
          failure: failure!,
        ),
      );
      return;
    }

    final updated = friendCode ?? _latestFriendCode;
    _latestFriendCode = updated;
    emit(FriendCodeSuccess(friendCode: updated));
  }

  void _observeProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = _profileRepository.observeProfile().listen(
      (result) => result.fold(
        ifLeft: (failure) => add(FriendCodeProfileFailed(failure)),
        ifRight: (user) =>
            add(FriendCodeProfileUpdated(user?.friendTag ?? '')),
      ),
      onError: (error, _) {
        TalkerService.instance.error(
          'syncTag observeProfile error',
          error,
        );
      },
    );
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
