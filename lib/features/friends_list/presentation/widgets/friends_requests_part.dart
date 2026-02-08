import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_request_model_ui.dart';
import 'package:taskify/features/friends_list/presentation/widgets/friend_request_card.dart';

class FriendsRequestsPart extends StatelessWidget {
  const FriendsRequestsPart({
    super.key,
    required this.incomingRequests,
    required this.outgoingRequests,
  });

  final List<FriendRequestModelUi> incomingRequests;
  final List<FriendRequestModelUi> outgoingRequests;

  @override
  Widget build(BuildContext context) {
    final showRequests = incomingRequests + outgoingRequests;
    final isOverflow = showRequests.length > 3;
    final requestsToShow = showRequests.take(3).toList();

    if (showRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < requestsToShow.length; i++) ...[
          if (i != 0) const SizedBox(height: 8),
          FriendRequestCard(request: requestsToShow[i], onPressed: () {}),
        ],
        if (isOverflow)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () {}, child: const Text('See all')),
          ),
      ],
    );
  }
}
