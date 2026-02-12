import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/core/utils/app_start_task.dart';
import 'package:taskify/features/friends/domain/usecases/friends_interactor.dart';

class FriendsStartupTask implements AppStartTask {
  FriendsStartupTask(this._interactor);

  final FriendsInteractor _interactor;

  @override
  String get id => 'friends_startup';

  @override
  bool get requiresAuth => true;

  @override
  Future<void> run() async {
    final futures = <Future<void>>[
      _interactor.getFriends().then(
        (result) => result.fold(
          ifLeft: (failure) => TalkerService.instance.error(
            'startupTask friends getFriends failed',
            failure,
          ),
          ifRight: (_) {},
        ),
      ),
      _interactor.getFriendRequests().then(
        (result) => result.fold(
          ifLeft: (failure) => TalkerService.instance.error(
            'startupTask friends getFriendRequests failed',
            failure,
          ),
          ifRight: (_) {},
        ),
      ),
    ];

    await Future.wait(futures);
  }
}
