import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/friend_info/bloc/friend_info_bloc.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';

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

  void _onRemoveFromFriendsPressed(BuildContext context) {
    context.read<FriendInfoBloc>().add(const FriendInfoRemovePressed());
  }

  List<Widget> _buildLoading() {
    return [
      const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      ),
    ];
  }

  List<Widget> _buildSuccess(
    BuildContext context,
    FriendModelUi friend,
    bool isFriend,
    bool isRemoving,
    String? removeErrorMessage,
  ) {
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
      if (isFriend) ...[
        const Gap(16),
        CardWithActions(
          actions: [
            CardActionEntry(
              CardAction(
                title: 'Remove from friends',
                titleColor: AppColorExtensions.getErrorColor(context),
                description: isRemoving ? 'Removing...' : null,
                isEnabled: !isRemoving,
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
      ],
      if (removeErrorMessage != null) ...[
        const Gap(12),
        Text(
          removeErrorMessage,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColorExtensions.getErrorColor(context),
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    return [
      Text(
        'Unable to load friend profile',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      const Gap(8),
      Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColorExtensions.getTextSecondaryColor(context),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendInfoBloc, FriendInfoState>(
      builder: (context, state) => FloatingBottomSheetLayout(
        children: switch (state) {
          FriendInfoLoading() => _buildLoading(),
          FriendInfoSuccess() => _buildSuccess(
            context,
            state.friend,
            state.isFriend,
            state.isRemoving,
            state.removeErrorMessage,
          ),
          FriendInfoError() => _buildError(context, state.message),
        },
      ),
    );
  }
}
