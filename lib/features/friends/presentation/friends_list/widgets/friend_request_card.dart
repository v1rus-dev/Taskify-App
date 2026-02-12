import 'package:flutter/material.dart';
import 'package:taskify/features/friends/presentation/friends_list/models/friend_request_model_ui.dart';
import 'package:design/design.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendRequestCard extends StatelessWidget {
  const FriendRequestCard({
    super.key,
    required this.request,
    required this.onPressed,
  });

  final FriendRequestModelUi request;
  final VoidCallback onPressed;

  String get description =>
      request.isIncoming ? 'Incoming friend request' : 'Waiting for approval';

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
                      child: RoundedSquareAvatar(name: request.user.name ?? ''),
                    ),
                    const Gap(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.user.name ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColorExtensions.getIconColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (request.isIncoming)
                  SvgPicture.asset(
                    AppIcons.warningInfo,
                    package: AppIcons.packageName,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColorExtensions.getWarningInfoColor(context),
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
