import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../controller/app_controller/app_controller.dart';
import 'package:get/get.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    super.key,
    required this.appController,
  });

  final AppController appController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final item = appController.texts
            .firstWhereOrNull((e) => e.isSelected);
        if (item == null) {
          Get.snackbar(
            "Info",
            "Please select a text first",
          );
          return;
        }
        Color pickerColor = item.color;
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Pick a color',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  item.color = pickerColor;
                  appController.texts.refresh();
                  Get.back();
                },
                child: const Text(
                  'Select',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: const Icon(
        Icons.color_lens,
        color: Colors.white,
      ),
    );
  }
}