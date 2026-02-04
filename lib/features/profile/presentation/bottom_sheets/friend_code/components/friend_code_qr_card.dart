import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FriendCodeQrCard extends StatelessWidget {
  const FriendCodeQrCard({
    super.key,
    required this.friendCode,
  });

  final String friendCode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 160,
          height: 160,
          child: QrImageView(
            padding: EdgeInsets.zero,
            data: friendCode,
            size: 160,
          ),
        ),
      ),
    );
  }
}
