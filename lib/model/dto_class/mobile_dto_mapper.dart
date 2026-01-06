import 'package:flutter/material.dart';
import '../dto_class/editable_text_dto.dart';
import '../app_model/app_model_class.dart';

extension EditableTextDTOToMobileModel on EditableTextDTO {
  EditableTextModel toMobileModel(
      double imageWidth,
      double imageHeight,
      ) {
    return EditableTextModel(
      text: text,
      x: xPercent * imageWidth,
      y: yPercent * imageHeight,
      fontSize: fontSizePercent * imageWidth,
      color: Color(int.parse('0xff$color')),
      fontWeight: _parseFontWeight(fontWeight),
    )
      ..relativeX = xPercent
      ..relativeY = yPercent;
  }
}

FontWeight _parseFontWeight(String fw) {
  switch (fw) {
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

// import '../model_class.dart';
// import 'editable_text_dto.dart';
//
// extension EditableTextDTOMapper on EditableTextDTO {
//   EditableTextItem toMobileItem(double imageWidth, double imageHeight) {
//     return EditableTextItem(
//       text: text,
//       x: xPercent * imageWidth,
//       y: yPercent * imageHeight,
//       fontSize: fontSizePercent * imageWidth,
//       colorHex: color,
//       fontWeight: fontWeight,
//       relativeX: xPercent,
//       relativeY: yPercent,
//     );
//   }
// }
