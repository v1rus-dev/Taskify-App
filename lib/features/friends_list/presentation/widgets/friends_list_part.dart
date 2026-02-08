import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:taskify/features/friends_list/presentation/widgets/friend_card.dart';
import 'package:design/design.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/friend_info/friend_info_bottom_sheet.dart';

class FriendsListPart extends StatelessWidget {
  const FriendsListPart({super.key, required this.friends});

  final List<FriendModelUi> friends;

  void _onFriendPressed(BuildContext context, FriendModelUi friend) {
    unfocusAndThen(
      context,
      () => showAppBottomSheet(
        context: context,
        type: AppBottomSheetType.floating,
        child: FriendInfoBottomSheetPage(friendId: friend.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => FriendCard(
          friend: friends[index],
          onPressed: () => _onFriendPressed(context, friends[index]),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: friends.length,
      ),
    );
  }
}
