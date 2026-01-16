
import 'package:flutter/painting.dart';

enum DefaultTagColor {
  red(id: 1, hex: '#EF4444'),
  orange(id: 2, hex: '#F97316'),
  amber(id: 3, hex: '#F59E0B'),
  green(id: 4, hex: '#22C55E'),
  teal(id: 5, hex: '#14B8A6'),
  blue(id: 6, hex: '#3B82F6'),
  indigo(id: 7, hex: '#6366F1'),
  purple(id: 8, hex: '#A855F7'),
  pink(id: 9, hex: '#EC4899'),
  gray(id: 10, hex: '#6B7280'),
  lime(id: 11, hex: '#84CC16'),
  skyBlue(id: 12, hex: '#0EA5E9');

  final int id;
  final String hex;

  const DefaultTagColor({required this.id, required this.hex});
}

extension DefaultTagColorExtension on DefaultTagColor {
  Color get color => _fromHex(hex);

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7 && hexString[0] == '#') {
      buffer.write('ff');
      buffer.write(hexString.substring(1));
    } else if (hexString.length == 6) {
      buffer.write('ff');
      buffer.write(hexString);
    } else if (hexString.length == 9 && hexString[0] == '#') {
      buffer.write(hexString.substring(1));
    } else {
      throw FormatException('Invalid hex color: $hexString');
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}