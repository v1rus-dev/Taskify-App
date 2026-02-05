import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddFriendQrCodeScanner extends StatelessWidget {
  const AddFriendQrCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, height: 400, child: QrImageView(data: 'https://www.google.com', size: 400,),);
  }
}