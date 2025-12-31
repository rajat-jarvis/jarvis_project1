import 'package:flutter/material.dart';

class EditableTextModel {
  String text;
  double x;
  double y;
  double fontSize;
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
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.isSelected = false,
    this.fontStyle = FontStyle.normal,
    this.rotation = 0.0,
    this.initialRotation = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": text,
      "left": x,
      "top": y,
      "fontSize": fontSize,
      "color": color,
      "fontWeight": fontWeight,
      "fontStyle": fontStyle,
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
