import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_model_ui.dart';
import 'package:design/design.dart';
import 'package:gap/gap.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friend, required this.onPressed});

  final FriendModelUi friend;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShadow(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: RoundedSquareAvatar(name: friend.name ?? ''),
                    ),
                    const Gap(8),
                    Column(
                      children: [
                        Text(
                          friend.name ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
