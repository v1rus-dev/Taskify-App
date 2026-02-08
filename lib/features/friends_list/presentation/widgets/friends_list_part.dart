import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:taskify/features/friends_list/presentation/widgets/friend_card.dart';

class FriendsListPart extends StatelessWidget {
  const FriendsListPart({super.key, required this.friends});

  final List<FriendModelUi> friends;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (context, index) =>
          FriendCard(friend: friends[index], onPressed: () {}),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: friends.length,
    );
  }
}
