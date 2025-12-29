import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../controller/app_controller/app_controller.dart';

class AppEditableTextScreen extends StatelessWidget {
  AppEditableTextScreen({super.key});

  final AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final canvasHeight = size.height * 0.7;
    const imageAspectRatio = 1440 / 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Textedit Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => appController.showTextPopup(),
        child: const Icon(Icons.text_fields),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => appController.submitText(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => appController.deselectAll(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: size.width,
                  height: canvasHeight * imageAspectRatio,
                  child: AspectRatio(
                    aspectRatio: imageAspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/happy_december_image.jpeg",
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Obx(() {
                          return GestureDetector(
                            onTap: appController.pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  appController.selectedImage.value != null
                                  ? FileImage(
                                      appController.selectedImage.value!,
                                    )
                                  : null,
                            ),
                          );
                        }),
                        Obx(() {
                          return Stack(
                            children: List.generate(
                              appController.texts.length,
                              (index) {
                                final item = appController.texts[index];
                                return Positioned(
                                  left: item.x,
                                  top: item.y,
                                  child: GestureDetector(
                                    onTap: () =>
                                        appController.selectText(index),
                                    onScaleStart: (details) {
                                      if (item.isSelected) {
                                        appController.startZoom(item, details);
                                      }
                                    },
                                    onScaleUpdate: (details) {
                                      if (!item.isSelected) return;
                                      const double dragSpeed = 0.3;
                                      item.x +=
                                          details.focalPointDelta.dx *
                                          dragSpeed;
                                      item.y +=
                                          details.focalPointDelta.dy *
                                          dragSpeed;
                                      appController.scaleText(
                                        item,
                                        details,
                                        details.focalPointDelta,
                                      );
                                      appController.texts.refresh();
                                    },

                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 80,
                                        minHeight: 80,
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: item.isSelected
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 1.5,
                                                    ),
                                                  )
                                                : null,
                                            child: Text(
                                              item.text,
                                              style: TextStyle(
                                                fontSize: item.fontSize,
                                                color: item.color,
                                                fontWeight: item.fontWeight,
                                                fontStyle: item.fontStyle,
                                              ),
                                            ),
                                          ),
                                          if (item.isSelected)
                                            Positioned(
                                              top: -12,
                                              right: -12,
                                              child: InkWell(
                                                onTap: () => appController
                                                    .showEditTextPopup(item),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 24,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final item = appController.texts.firstWhereOrNull(
                            (e) => e.isSelected,
                          );
                          if (item == null) {
                            Get.snackbar("Info", "Please select a text first");
                            return;
                          }
                          Color pickerColor = item.color;
                          Get.dialog(
                            AlertDialog(
                              title: const Text(
                                'Pick a color',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                      ),

                      SizedBox(width: 10),

                      Obx(() {
                        final hasSelection = appController.texts.any(
                          (e) => e.isSelected,
                        );
                        // if (!hasSelection) return const SizedBox.shrink();
                        return ElevatedButton.icon(
                          onPressed: () =>
                              appController.showDuplicateTextPopup(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Text'),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Obx(() {
                    final selectedIndex = appController.texts.indexWhere(
                      (e) => e.isSelected,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedIndex == -1
                              ? 'X: - -'
                              : 'X: ${appController.texts[selectedIndex].x.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedIndex == -1
                              ? 'Y: - -'
                              : 'Y: ${appController.texts[selectedIndex].y.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),

                  Obx(() {
                    final hasSelection = appController.texts.any(
                      (e) => e.isSelected,
                    );

                    // if (!hasSelection) return const SizedBox.shrink();

                    return ElevatedButton.icon(
                      onPressed: () => appController.deleteSelectedText(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
