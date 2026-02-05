import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/domain/app_startup/app_start_task.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';

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
      _interactor.getIncomingRequests().then(
        (result) => result.fold(
          ifLeft: (failure) => TalkerService.instance.error(
            'startupTask friends getIncomingRequests failed',
            failure,
          ),
          ifRight: (_) {},
        ),
      ),
      _interactor.getOutgoingRequests().then(
        (result) => result.fold(
          ifLeft: (failure) => TalkerService.instance.error(
            'startupTask friends getOutgoingRequests failed',
            failure,
          ),
          ifRight: (_) {},
        ),
      ),
    ];

    await Future.wait(futures);
  }
}
