import 'package:flutter/material.dart';

class CardAction {
  final String title;
  final String description;
  final Color? descriptionColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  CardAction({
    required this.title,
    required this.description,
    this.descriptionColor,
    this.icon,
    this.onPressed,
    this.isEnabled = true,
  });
}
