import 'package:flutter/material.dart';

class FriendCodeLoader extends StatelessWidget {
  const FriendCodeLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}
