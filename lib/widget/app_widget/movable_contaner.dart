import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/app_controller/app_controller.dart';
import '../../model/app_model/app_model_class.dart';

class movableBox extends StatelessWidget {
  const movableBox({
    super.key,
    required this.item,
    required this.appController,
  });

  final EditableTextModel item;
  final AppController appController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 80, minHeight: 80),
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
                      padding: EdgeInsets.only(bottom: 40),
                      child: InkWell(
                        onTap: () => appController.deleteSelectedText(),
                        borderRadius: BorderRadius.circular(16),
                        child: Icon(Icons.delete, size: 24, color: Colors.blue),
                      ),
                    ),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: item.isSelected
                        ? BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1.5),
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: InkWell(
                        onTap: () => appController.showEditTextPopup(item),
                        borderRadius: BorderRadius.circular(16),
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
        ],
      ),
    );
  }
}
