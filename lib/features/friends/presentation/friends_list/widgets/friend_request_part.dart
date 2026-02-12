import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/friends/presentation/friends_list/models/friend_request_model_ui.dart';
import 'package:taskify/features/friends/presentation/friends_list/widgets/friend_request_card.dart';
import 'package:design/design.dart';
import 'package:taskify/features/friends/presentation/friend_request_bottom_sheet/friend_request_bottom_sheet.dart';

class FriendRequestPart extends StatelessWidget {
  const FriendRequestPart({
    super.key,
    required this.incomingRequests,
    required this.outgoingRequests,
    this.maxRequestsToShow = 2,
  });

  final List<FriendRequestModelUi> incomingRequests;
  final List<FriendRequestModelUi> outgoingRequests;

  final int maxRequestsToShow;

  void _onFriendRequestPressed(
    BuildContext context,
    FriendRequestModelUi request,
  ) {
    unfocusAndThen(
      context,
      () => showAppBottomSheet(
        context: context,
        type: AppBottomSheetType.floating,
        child: FriendRequestBottomSheetPage(request: request),
      ),
    );
  }

  void _onSeeAllPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final combinedRequests = [...incomingRequests, ...outgoingRequests];
    final requestsToShow = combinedRequests.take(maxRequestsToShow).toList();
    final isOverflow = combinedRequests.length > maxRequestsToShow;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requests',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            ...requestsToShow.map(
              (request) => FriendRequestCard(
                request: request,
                onPressed: () => _onFriendRequestPressed(context, request),
              ),
            ),
            if (isOverflow)
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('See all'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
