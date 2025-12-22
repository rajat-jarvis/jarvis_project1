import 'package:drag_project/view/style_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../model/model_class.dart';

class EditableTextScreen extends StatelessWidget {
  EditableTextScreen({super.key});

  final controller  = Get.put(EditableTextController());

  final titleCtrl   = TextEditingController();
  final sizeCtrl    = TextEditingController();
  final colorCtrl   = TextEditingController();
  String fontWeight = 'FontWeight.w400';

  void showTextPopup({EditableTextItem? baseItem}) {
    titleCtrl.clear();
    sizeCtrl.text  = (baseItem?.fontSize ?? 18).toString();
    colorCtrl.text = baseItem?.colorHex ?? '000000';
    fontWeight = baseItem?.fontWeight ?? 'FontWeight.w400';

    Get.defaultDialog(
      title: 'Add Text',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(labelText: 'Text'),
          ),
          TextField(
            controller: sizeCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Font Size'),
          ),
          TextField(
            controller: colorCtrl,
            decoration: const InputDecoration(labelText: 'Hex Color'),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: fontWeight,
            items: const [
              DropdownMenuItem(value: 'FontWeight.w300', child: Text('w300')),
              DropdownMenuItem(value: 'FontWeight.w400', child: Text('w400')),
              DropdownMenuItem(value: 'FontWeight.w500', child: Text('w500')),
              DropdownMenuItem(value: 'FontWeight.w600', child: Text('w600')),
              DropdownMenuItem(value: 'FontWeight.bold', child: Text('Bold')),
            ],
            onChanged: (v) => fontWeight = v!,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  controller.addText(
                    EditableTextItem(
                      text: titleCtrl.text.isEmpty
                          ? 'New Text'
                          : titleCtrl.text,
                      x: (baseItem?.x ?? 100) + 30,
                      y: (baseItem?.y ?? 100) + 30,
                      fontSize:
                          double.tryParse(sizeCtrl.text) ??
                          baseItem?.fontSize ??
                          18,
                      colorHex: colorCtrl.text,
                      fontWeight: fontWeight,
                    ),
                  );
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

  @override
  Widget build(BuildContext context) {
    final imageWidth  = MediaQuery.of(context).size.width * 0.9;
    final imageHeight = imageWidth * (1024 / 1440);
    return Scaffold(
      appBar: AppBar(title: const Text('Text Edit Screen'),
          centerTitle: true
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Obx(() {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.deselect();
                },
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/happy_december_image.jpeg',
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.fill,
                      ),
                      ...controller.texts.asMap().entries.map((entry) {
                        final i = entry.key;
                        final t = entry.value;
                        return Positioned(
                          left: t.x,
                          top: t.y,
                          child: GestureDetector(
                            onTap: () => controller.select(i),
                            onPanUpdate: (d) {
                              controller.updatePosition(
                                i,
                                t.x + d.delta.dx,
                                t.y + d.delta.dy,
                              );
                            },
                            child: Container(
                              decoration: controller.selectedIndex.value == i
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    )
                                  : null,
                              child: Text(
                                t.text,
                                style: TextStyle(
                                  fontSize: t.fontSize,
                                  color: hexToColor(t.colorHex),
                                  fontWeight: parseWeight(t.fontWeight),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 15,),

            Obx(() {
              final index = controller.selectedIndex.value;
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == null
                              ? 'X: - -'
                              : 'X: ${controller.texts[index].x.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          index == null
                              ? 'Y: - -'
                              : 'Y: ${controller.texts[index].y.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () => showTextPopup(),
                          child: const Text(
                            'Create Text',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            final i = controller.selectedIndex.value;
                            if (i != null) {
                              showTextPopup(baseItem: controller.texts[i]);
                            } else {
                              showTextPopup();
                            }
                          },
                          child: const Text(
                            'Add Text',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: index == null
                              ? null
                              : controller.deleteSelected,
                          child: const Text(
                            'Delete ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              );
            }),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
