import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/bloc/add_friend_bloc.dart';
import 'package:taskify/features/friends_list/presentation/formatters/friend_code_input_formatter.dart';
import 'package:design/design.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/friends_list/presentation/models/add_friend_state_type.dart';

class AddFriendTextField extends StatelessWidget {
  const AddFriendTextField({super.key, required this.controller});

  final TextEditingController controller;

  void _onOpenScanner(BuildContext context) {
    context.read<AddFriendBloc>().add(
      const AddFriendSwitchMode(AddFriendStateType.qrCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFieldNew(
      hint: 'Enter friend code',
      controller: controller,
      inputFormatters: const [FriendCodeInputFormatter()],
      decoration: InputDecoration(hintText: 'Enter friend code'),
      trailing: SizedBox(
        width: 24,
        height: 24,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => _onOpenScanner(context),
            customBorder: const CircleBorder(),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: SvgPicture.asset(
                  AppIcons.qrCode,
                  package: AppIcons.packageName,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    context.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
