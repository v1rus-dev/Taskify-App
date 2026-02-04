import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:animated_visibility/animated_visibility.dart';
import 'package:taskify/features/profile/presentation/widgets/friends_card.dart';

class FriendsPart extends StatelessWidget {
  const FriendsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.profileUser != curr.profileUser,
      builder: (context, state) {
        final user = state.profileUser;
        return AnimatedVisibility(
          visible: user != null,
          child: user != null ? FriendsCard() : const SizedBox.shrink(),
        );
      },
    );
  }
}
