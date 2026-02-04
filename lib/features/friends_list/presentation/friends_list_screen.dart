import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/friends_list/presentation/bloc/friends_list_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/app/router/app_router.dart';

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsListBloc(),
      child: const FriendsListScreen(),
    );
  }
}

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  void _onBackPressed(BuildContext context) {
    appRouter.pop();
  }

  void _onAddFriendPressed(BuildContext context) {
    // TODO: Implement add friend logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: AppLocalizations.of(context)?.friends ?? '',
        onBack: () => _onBackPressed(context),
        trailingWidget: IconButton(
          onPressed: () => _onAddFriendPressed(context),
          icon: SvgPicture.asset(
            AppIcons.addUser,
            package: AppIcons.packageName,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColorExtensions.getIconColor(context),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: BlocBuilder<FriendsListBloc, FriendsListState>(
        builder: (context, state) {
          return CustomScrollView(slivers: []);
        },
      ),
    );
  }
}
