import '../model_class.dart';
import 'editable_text_dto.dart';

extension EditableTextItemMapper on EditableTextItem {
  EditableTextDTO toDTO(double imageWidth) {
    return EditableTextDTO(
      text: text,
      xPercent: relativeX,
      yPercent: relativeY,
      fontSizePercent: fontSize / imageWidth,
      color: colorHex,
      fontWeight: fontWeight,
    );
  }
}
