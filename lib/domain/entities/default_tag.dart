import 'package:flutter/painting.dart';

enum DefaultTag {
  health(id: 1, color: Color(0xFFFF027A)),
  work(id: 2, color: Color(0xFF4E80FF)),
  mentalHealth(id: 3, color: Color(0xFF12D788)),
  personality(id: 4, color: Color(0xFFB005FF)),
  other(id: 5, color: Color(0xFF8E8E8E));

  final int id;
  final Color color;

  const DefaultTag({required this.id, required this.color});
}