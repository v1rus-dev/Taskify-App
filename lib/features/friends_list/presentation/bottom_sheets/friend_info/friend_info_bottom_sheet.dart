import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/friend_info/bloc/friend_info_bloc.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:flutter_svg/svg.dart';

class FriendInfoBottomSheetPage extends StatelessWidget {
  const FriendInfoBottomSheetPage({super.key, required this.friendId});
  final String friendId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendInfoBloc(friendId: friendId)..add(const FriendInfoStarted()),
      child: const FriendInfoBottomSheet(),
    );
  }
}

class FriendInfoBottomSheet extends StatelessWidget {
  const FriendInfoBottomSheet({super.key});

  void _onAddToSpacePressed(BuildContext context) {}

  void _onRemoveFromFriendsPressed(BuildContext context) {}

  List<Widget> _buildLoading() {
    return [
      Center(
        child: const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      ),
    ];
  }

  List<Widget> _buildSuccess(BuildContext context, FriendModelUi friend) {
    final theme = Theme.of(context);
    return [
      Text(
        friend.name ?? '',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      const Gap(8),
      Text(
        'No shared spaces yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColorExtensions.getTextSecondaryColor(context),
        ),
      ),
      const Gap(16),
      CardWithActions(
        actions: [
          CardActionEntry(
            CardAction(
              title: 'Add to space',
              onPressed: () => _onAddToSpacePressed(context),
            ),
          ),
        ],
      ),
      const Gap(16),
      CardWithActions(
        actions: [
          CardActionEntry(
            CardAction(
              title: 'Remove from friends',
              titleColor: AppColorExtensions.getErrorColor(context),
              showArrow: false,
              icon: SvgPicture.asset(
                AppIcons.trash,
                package: AppIcons.packageName,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColorExtensions.getErrorColor(context),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => _onRemoveFromFriendsPressed(context),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendInfoBloc, FriendInfoState>(
      builder: (context, state) => FloatingBottomSheetLayout(
        children: switch (state) {
          FriendInfoLoading() => _buildLoading(),
          FriendInfoSuccess() => _buildSuccess(context, state.friend),
        },
      ),
    );
  }
}
