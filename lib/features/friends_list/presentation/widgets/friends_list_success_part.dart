import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';

class FriendsListSuccessPart extends StatelessWidget {
  const FriendsListSuccessPart({super.key, required this.friends});

  final List<FriendModelUi> friends;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
