import 'package:equatable/equatable.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';

class FriendRequestModelUi extends Equatable {
  const FriendRequestModelUi({
    required this.requestId,
    required this.user,
  });

  final String requestId;
  final FriendModelUi user;

  @override
  List<Object?> get props => [requestId, user];
}

extension FriendRequestReadUiMapper on FriendRequestEntity {
  FriendRequestModelUi toUiModel() {
    return FriendRequestModelUi(
      requestId: requestId,
      user: user.toUiModel(),
    );
  }
}