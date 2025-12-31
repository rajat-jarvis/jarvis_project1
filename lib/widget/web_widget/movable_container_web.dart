import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/controller.dart';
import '../../model/model_class.dart';
import '../../view/style_util.dart';

class MovableTextContainer extends StatelessWidget {
  const MovableTextContainer({
    super.key,
    required this.textItem,
    required this.controller,
    required this.index,
  });

  final EditableTextItem textItem;
  final EditableTextController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: textItem.x,
      top: textItem.y,
      child: GestureDetector(
        onTap: () => controller.select(index),
        onPanUpdate: (d) {
          controller.updatePosition(
            index,
            textItem.x + d.delta.dx,
            textItem.y + d.delta.dy,
          );
        },
        child: Container(
          decoration:
          controller.selectedIndex.value == index
              ? BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 1.5,
            ),
          )
              : null,
          child: Text(
            textItem.text,
            style: TextStyle(
              fontSize: textItem.fontSize,
              color: hexToColor(textItem.colorHex),
              fontWeight: parseWeight(textItem.fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}