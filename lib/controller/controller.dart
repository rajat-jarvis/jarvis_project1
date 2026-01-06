import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/dto_class/editable_text_mapper.dart';
import '../model/model_class.dart';

class EditableTextController extends GetxController {
  var texts = <EditableTextItem>[].obs;
  var selectedIndex = RxnInt();
  EditableTextItem? lastDeletedItem;
  int? lastDeletedIndex;
  final List<Map<String,dynamic>> payload = [];

  void select(int index) => selectedIndex.value = index;
  void deselect() => selectedIndex.value = null;

  void addText(EditableTextItem item, double imageWidth, double imageHeight) {

    item.updateRelative(imageWidth, imageHeight);
    texts.add(item);
    selectedIndex.value = texts.length - 1;
  }

  void updatePosition(
      int index,
      double x,
      double y,
      double imageWidth,
      double imageHeight,
      ) {
    final item = texts[index];

    final textPainter = TextPainter(
      text: TextSpan(
        text: item.text,
        style: TextStyle(
          fontSize: item.fontSize,
          fontWeight: FontWeight.values.firstWhere(
                (e) => e.toString() == item.fontWeight,
            orElse: () => FontWeight.w400,
          ),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    final clampedX = x.clamp(0.0, imageWidth - textWidth);
    final clampedY = y.clamp(0.0, imageHeight - textHeight);

    item.x = clampedX;
    item.y = clampedY;

    item.updateRelative(imageWidth, imageHeight);
    texts.refresh();
  }

  void deleteSelected() {
    if (selectedIndex.value == null) return;
    lastDeletedIndex = selectedIndex.value;
    lastDeletedItem = texts[lastDeletedIndex!];
    texts.removeAt(lastDeletedIndex!);
    selectedIndex.value = null;
  }

  void restoreLastDeleted() {
    if (lastDeletedItem == null || lastDeletedIndex == null) return;
    texts.insert(lastDeletedIndex!, lastDeletedItem!);
    selectedIndex.value = lastDeletedIndex;
    lastDeletedItem = null;
    lastDeletedIndex = null;
  }

  void submitText(double imageWidth) {
    //final List<Map<String, dynamic>> payload = [];

    for (final item in texts) {
      final dto = item.toDTO(imageWidth);
      payload.add(dto.toJson());
    }
    print(payload);
  }

  // void submitText() {
  //   final List<Map<String, dynamic>> textDetails = texts.map((item) => item.toJson()).toList();
  //   print(textDetails);
  // }

  void onScreenResize(double imageWidth, double imageHeight) {
    for (var t in texts) {
      t.updateAbsolute(imageWidth, imageHeight);
    }
    texts.refresh();
  }
}

