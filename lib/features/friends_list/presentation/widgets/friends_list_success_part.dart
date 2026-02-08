import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/bloc/friends_list_bloc.dart';
import 'package:taskify/features/friends_list/presentation/widgets/friends_requests_part.dart';
import 'package:taskify/features/friends_list/presentation/widgets/friends_list_part.dart';
import 'package:gap/gap.dart';

class FriendsListSuccessPart extends StatelessWidget {
  const FriendsListSuccessPart({super.key, required this.state});

  final FriendsListState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.requestsIsNotEmpty)
          FriendsRequestsPart(
            incomingRequests: state.incomingRequests,
            outgoingRequests: state.outgoingRequests,
          ),
        if (state.friends.isNotEmpty) ...[
          const Gap(12),
          FriendsListPart(friends: state.friends),
        ],
      ],
    );
  }
}
