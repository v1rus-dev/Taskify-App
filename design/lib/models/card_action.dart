import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardAction {
  final String title;
  final String? description;
  final Color? descriptionColor;
  final Color? titleColor;  
  final SvgPicture? icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  CardAction({
    required this.title,
    this.description,
    this.descriptionColor,
    this.titleColor,
    this.icon,
    this.onPressed,
    this.isEnabled = true,
  });
}
