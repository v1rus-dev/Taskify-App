import 'package:flutter/material.dart';

enum AvatarColor {
  sunset(Color(0xFFE45858)),
  tangerine(Color(0xFFF08A24)),
  amber(Color(0xFFF4B400)),
  lime(Color(0xFF7CB342)),
  emerald(Color(0xFF2E7D32)),
  teal(Color(0xFF00897B)),
  cyan(Color(0xFF00ACC1)),
  azure(Color(0xFF1E88E5)),
  indigo(Color(0xFF3949AB)),
  violet(Color(0xFF7E57C2)),
  magenta(Color(0xFFD81B60)),
  rose(Color(0xFFEC407A));

  const AvatarColor(this.color);

  final Color color;
}