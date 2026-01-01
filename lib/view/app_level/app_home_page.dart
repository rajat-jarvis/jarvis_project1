import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/app_controller/app_controller.dart';
import '../../widget/app_widget/add_text_button.dart';
import '../../widget/app_widget/color_picker_button.dart';

class AppEditableTextScreen extends StatelessWidget {
  AppEditableTextScreen({super.key});

  final AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final canvasHeight = size.height * 0.6;
    const imageAspectRatio = 1440 / 1024;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => appController.deselectAll(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: canvasHeight,
                      child: AspectRatio(
                        aspectRatio: imageAspectRatio,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final imageWidth = constraints.maxWidth;
                            final imageHeight = constraints.maxHeight;

                            return Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
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
                                          appController.selectedImage.value !=
                                              null
                                          ? FileImage(
                                              appController
                                                  .selectedImage
                                                  .value!,
                                            )
                                          : null,
                                    ),
                                  );
                                }),

                                Obx(() {
                                  return Stack(
                                    children: List.generate(appController.texts.length, (
                                      index,
                                    ) {
                                      final item = appController.texts[index];
                                      final key = GlobalKey();

                                      return Positioned(
                                        left: item.x,
                                        top: item.y,
                                        child: GestureDetector(
                                          onTap: () =>
                                              appController.selectText(index),
                                          onScaleStart: (details) {
                                            if (item.isSelected) {
                                              appController.startZoom(
                                                item,
                                                details,
                                              );
                                            }
                                          },
                                          onScaleUpdate: (details){
                                            if (!item.isSelected) return;
                                            final dragSpeed = 0.3;

                                            item.x += details.focalPointDelta.dx * dragSpeed;
                                            item.y += details.focalPointDelta.dy * dragSpeed;
                                            const double padding = 8 * 5;


                                            appController.scaleText(item, details, details.focalPointDelta);


                                            final textPainter = TextPainter(
                                              text: TextSpan(
                                                text: item.text,
                                                style: TextStyle(
                                                  fontSize: item.fontSize,
                                                  fontWeight: item.fontWeight,
                                                  fontStyle: item.fontStyle,
                                                ),
                                              ),
                                              textDirection: TextDirection.ltr,
                                            )..layout();

                                            final textWidth = textPainter.width + padding;
                                            final textHeight = textPainter.height + padding;


                                            item.x = item.x.clamp(0.0, imageWidth - textWidth);
                                            item.y = item.y.clamp(0.0, imageHeight - textHeight);

                                            item.rotation = item.initialRotation + details.rotation;


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
                                                Positioned(
                                                  child: Transform.rotate(
                                                    angle: item.rotation,
                                                    child: Row(
                                                      children: [
                                                        if (item.isSelected)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  bottom: 40,
                                                                ),
                                                            child: InkWell(
                                                              onTap: () =>
                                                                  appController
                                                                      .deleteSelectedText(),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 24,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),

                                                        Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                4,
                                                              ),
                                                          decoration:
                                                              item.isSelected
                                                              ? BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 1.5,
                                                                  ),
                                                                )
                                                              : null,
                                                          child: Text(
                                                            item.text,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  item.fontSize,
                                                              color: item.color,
                                                              fontWeight: item
                                                                  .fontWeight,
                                                              fontStyle: item
                                                                  .fontStyle,
                                                            ),
                                                          ),
                                                        ),

                                                        if (item.isSelected)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  bottom: 40,
                                                                ),
                                                            child: InkWell(
                                                              onTap: () =>
                                                                  appController
                                                                      .showEditTextPopup(
                                                                        item,
                                                                      ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                size: 24,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ColorPickerButton(appController: appController),

                            SizedBox(width: 10),

                            Obx(() {
                              final hasSelection = appController.texts.any(
                                (e) => e.isSelected,
                              );
                              return AddTextButton(
                                appController: appController,
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
                                    ? 'X:  - -'
                                    : 'X: ${appController.texts[selectedIndex].x.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedIndex == -1
                                    ? 'Y:  - -'
                                    : 'Y: ${appController.texts[selectedIndex].y.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

