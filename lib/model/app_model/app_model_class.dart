import 'package:flutter/material.dart';

class EditableTextModel {
  final String id;
  String text;
  double x;
  double y;
  double fontSize;
  double relativeX;
  double relativeY;
  double relativeFontSize;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  bool isSelected;
  double rotation;
  double initialRotation;

  EditableTextModel({
    required this.text,
    required this.x,
    required this.y,
    this.fontSize = 18.0,
    this.relativeX = 0,
    this.relativeY = 0,
    this.relativeFontSize = 0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.isSelected = false,
    this.fontStyle = FontStyle.normal,
    this.rotation = 0.0,
    this.initialRotation = 0.0,
    String? id,
  }) : id = id ?? UniqueKey().toString();

  void updateRelative(double webWidth, double webHeight) {
    relativeX = x / webWidth;
    relativeY = y / webHeight;
    relativeFontSize = fontSize / webWidth;
  }

  void updateAbsolute(double deviceWidth, double deviceHeight) {
    x = relativeX * deviceWidth;
    y = relativeY * deviceHeight;
    fontSize = relativeFontSize * deviceWidth;
  }

  Map<String, dynamic> toJson(double deviceWidth, double deviceHeight) {
    return {
      "title": text,
      "left": x / deviceWidth,
      "top": y / deviceHeight,
      "fontSize": fontSize / deviceWidth,
      "color": color.value,
      "fontWeight": fontWeightStr,
      "fontStyle": fontStyle.toString(),
    };
  }
}

extension FontWeightExtension on EditableTextModel {
  String get fontWeightStr {
    if (fontWeight == FontWeight.w300) return 'FontWeight.w300';
    if (fontWeight == FontWeight.w400) return 'FontWeight.w400';
    if (fontWeight == FontWeight.w500) return 'FontWeight.w500';
    if (fontWeight == FontWeight.w600) return 'FontWeight.w600';
    if (fontWeight == FontWeight.bold) return 'FontWeight.bold';
    return 'FontWeight.w400';
  }
}




