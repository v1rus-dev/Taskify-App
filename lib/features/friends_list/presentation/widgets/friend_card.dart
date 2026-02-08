import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:design/design.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friend, required this.onPressed});

  final FriendModelUi friend;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppShadow(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
        ),
      ),
    );
  }
}
