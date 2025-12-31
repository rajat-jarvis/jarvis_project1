import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/app_model/app_model_class.dart';

class AppController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final RxList<EditableTextModel> texts = <EditableTextModel>[].obs;

  double _startFontSize = 0;
  Offset _startDragPosition = Offset.zero;

  double rotation = 0.0;
  double initialRotation = 0.0;

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  void addTextModel(EditableTextModel model) => texts.add(model);

  void updateTextPosition(int index, double dx, double dy) {
    texts[index].x += dx;
    texts[index].y += dy;
    texts.refresh();
  }

  void selectText(int index) {
    for (int i = 0; i < texts.length; i++) {
      texts[i].isSelected = i == index;
    }
    texts.refresh();
  }

  void deselectAll() {
    for (var t in texts) t.isSelected = false;
    texts.refresh();
  }

  void deleteSelectedText() {
    final index = texts.indexWhere((e) => e.isSelected);
    if (index == -1) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Text'),
        content: const Text('Are you sure you want to delete this text?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              texts.removeAt(index);
              texts.refresh();
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void resizeText(int index, double delta) {
    texts[index].fontSize += delta;
    if (texts[index].fontSize < 8) texts[index].fontSize = 8;
    texts.refresh();
  }

  void editTextValue(int index, EditableTextModel model) {
    texts[index] = model;
    texts.refresh();
  }

  void showTextPopup({EditableTextModel? baseItem}) {
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController sizeCtrl = TextEditingController();
    final TextEditingController colorCtrl = TextEditingController();
    String fontWeightStr = 'FontWeight.w400';
    FontStyle fontStyle = baseItem?.fontStyle ?? FontStyle.normal;

    titleCtrl.text = baseItem?.text ?? '';
    sizeCtrl.text = (baseItem?.fontSize ?? 18).toString();
    colorCtrl.text = baseItem != null
        ? baseItem.color.value.toRadixString(16).padLeft(8, '0').substring(2)
        : '000000';
    fontWeightStr = baseItem?.fontWeightStr ?? 'FontWeight.w400';

    Get.defaultDialog(
      title: baseItem == null ? 'Add Text' : 'Edit Text',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(labelText: 'Text'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: sizeCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Font Size'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: colorCtrl,
            decoration: const InputDecoration(labelText: 'Hex Color '),
          ),

          const SizedBox(height: 8),
          DropdownButtonFormField<FontStyle>(
            value: fontStyle,
            items: const [
              DropdownMenuItem(value: FontStyle.normal, child: Text('Normal')),
              DropdownMenuItem(value: FontStyle.italic, child: Text('Italic')),
            ],
            onChanged: (v) {
              if (v != null) fontStyle = v;
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: fontWeightStr,
            items: const [
              DropdownMenuItem(value: 'FontWeight.w300', child: Text('w300')),
              DropdownMenuItem(value: 'FontWeight.w400', child: Text('w400')),
              DropdownMenuItem(value: 'FontWeight.w500', child: Text('w500')),
              DropdownMenuItem(value: 'FontWeight.w600', child: Text('w600')),
              DropdownMenuItem(value: 'FontWeight.bold', child: Text('Bold')),
            ],
            onChanged: (v) => fontWeightStr = v!,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final color = Color(
                    int.parse('FF${colorCtrl.text}', radix: 16),
                  );
                  final fontWeight = parseFontWeight(fontWeightStr);
                  final newModel = EditableTextModel(
                    text: titleCtrl.text.isEmpty ? 'New Text' : titleCtrl.text,
                    x: (baseItem?.x ?? 100) + 30,
                    y: (baseItem?.y ?? 100) + 30,
                    fontSize: double.tryParse(sizeCtrl.text) ?? 18,
                    color: color,
                    fontWeight: fontWeight,
                    fontStyle: fontStyle,
                  );

                  if (baseItem == null) {
                    addTextModel(newModel);
                  } else {
                    final index = texts.indexOf(baseItem);
                    editTextValue(index, newModel);
                  }

                  Get.back();
                },
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showEditTextPopup(EditableTextModel item) {
    final TextEditingController editCtrl = TextEditingController();
    editCtrl.text = item.text;

    Get.defaultDialog(
      title: 'Edit Text',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: editCtrl,
            decoration: const InputDecoration(labelText: 'Text'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final index = texts.indexOf(item);
                  if (index != -1) {
                    // Update only the text string, keep other properties
                    texts[index].text = editCtrl.text.isEmpty
                        ? item.text
                        : editCtrl.text;
                    texts.refresh();
                  }
                  Get.back();
                },
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startResize(EditableTextModel item, DragStartDetails details) {
    _startFontSize = item.fontSize;
    _startDragPosition = details.globalPosition;
  }

  void updateResize(EditableTextModel item, DragUpdateDetails details) {
    final dy = _startDragPosition.dy - details.globalPosition.dy;

    final newSize = _startFontSize + (dy * 0.15);

    item.fontSize = newSize.clamp(10.0, 120.0);
    texts.refresh();
  }

  void endResize() {}

  void submitText() {
    final List<Map<String, dynamic>> textDetails = texts
        .map((item) => item.toJson())
        .toList();

    print(textDetails);
  }

  void startZoom(EditableTextModel item, ScaleStartDetails details) {
    _startFontSize = item.fontSize;
    item.initialRotation = item.rotation;
  }

  void updateZoom(EditableTextModel item, ScaleUpdateDetails details) {
    final newSize = (_startFontSize * details.scale).clamp(10.0, 120.0);
    item.fontSize = newSize;
    texts.refresh();
  }

  void scaleText(
    EditableTextModel item,
    ScaleUpdateDetails details,
    Offset delta,
  ) {
    item.x += delta.dx;
    item.y += delta.dy;

    item.fontSize = (_startFontSize * details.scale).clamp(10.0, 120.0);

    texts.refresh();
  }

  void showDuplicateTextPopup() {
    final selected = texts.firstWhereOrNull((e) => e.isSelected);
    if (selected == null) return;

    final TextEditingController textCtrl = TextEditingController(
      text: selected.text,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Add Text'),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(hintText: 'Enter text'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              for (final t in texts) {
                t.isSelected = false;
              }

              texts.add(
                EditableTextModel(
                  text: textCtrl.text,
                  x: selected.x + 20,
                  y: selected.y + 20,
                  fontSize: selected.fontSize,
                  color: selected.color,
                  fontWeight: selected.fontWeight,
                  fontStyle: selected.fontStyle,
                  isSelected: true,
                ),
              );

              texts.refresh();
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  FontWeight parseFontWeight(String str) {
    switch (str) {
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
}
