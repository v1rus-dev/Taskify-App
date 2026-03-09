import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:taskify/core/auth/auth_state.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/activity/domain/usecases/activity_interactor.dart';
import 'package:taskify/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/features/root/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:taskify/features/settings/domain/usecases/app_configuration_interactor.dart';
import 'package:taskify/features/spaces/presentation/bloc/spaces_bloc.dart';
import 'package:taskify/features/sync/domain/usecases/request_sync_use_case.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late final HomeBloc _homeBloc;
  late final SpacesBloc _spacesBloc;
  late final ActivityBloc _activityBloc;
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      taskInteractor: locator<TaskInteractor>(),
      subTaskInteractor: locator<SubTaskInteractor>(),
      requestSyncUseCase: locator<RequestSyncUseCase>(),
    )..add(const HomeStarted());
    _spacesBloc = SpacesBloc();
    _activityBloc = ActivityBloc(
      activityInteractor: locator<ActivityInteractor>(),
    )..add(const ActivityStarted());
    _profileBloc = ProfileBloc(
      appConfigurationInteractor: locator<AppConfigurationInteractor>(),
      profileRepository: locator<ProfileRepository>(),
    )..add(const ProfileStarted());
  }

  void _showAuthLoadingDialog(BuildContext context) {
    showAppLoadingDialog(context: context);
  }

  void _dismissAuthLoadingDialog(BuildContext context) {
    dismissAppLoadingDialog(context);
  }

  @override
  void dispose() {
    _homeBloc.close();
    _spacesBloc.close();
    _activityBloc.close();
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>.value(value: _homeBloc),
        BlocProvider<SpacesBloc>.value(value: _spacesBloc),
        BlocProvider<ActivityBloc>.value(value: _activityBloc),
        BlocProvider<ProfileBloc>.value(value: _profileBloc),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        listener: (context, state) {
          if (state.isLoading) {
            _showAuthLoadingDialog(context);
          } else {
            _dismissAuthLoadingDialog(context);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              widget.navigationShell,
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 20,
                      right: 20,
                    ),
                    child: AppBottomNavigationBar(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
