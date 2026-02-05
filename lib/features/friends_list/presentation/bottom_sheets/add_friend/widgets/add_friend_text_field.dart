import 'package:flutter/material.dart';
import 'package:taskify/features/friends_list/presentation/formatters/friend_code_input_formatter.dart';

class AddFriendTextField extends StatelessWidget {
  const AddFriendTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: const [FriendCodeInputFormatter()],
      decoration: InputDecoration(
        hintText: 'Enter friend code',
      ),
    );
  }
}
