import 'dart:ui';

Color hexToColor(String hex) =>
    Color(int.parse('FF$hex', radix: 16));

FontWeight parseWeight(String w) {
  switch (w) {
    case 'FontWeight.w300':
      return FontWeight.w300;
    case 'FontWeight.w400':
      return FontWeight.w400;
    case 'FontWeight.w500':
      return FontWeight.w500;
    case 'FontWeight.w600':
      return FontWeight.w600;
    case 'FontWeight.bold':
      return FontWeight.bold;
    default:
      return FontWeight.w400;
  }
}