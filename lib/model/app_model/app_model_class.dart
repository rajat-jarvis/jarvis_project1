import 'package:flutter/material.dart';

class EditableTextModel {
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
    this.relativeX=0,
    this.relativeY=0,
    this.relativeFontSize=0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.isSelected = false,
    this.fontStyle = FontStyle.normal,
    this.rotation = 0.0,
    this.initialRotation = 0.0,
  });

  void updateRelative(double imageWidth, double imageHeight) {
    relativeX = x / imageWidth;
    relativeY = y / imageHeight;
    relativeFontSize = fontSize / imageWidth;
  }

  void updateAbsolute(double imageWidth, double imageHeight) {
    x = relativeX * imageWidth;
    y = relativeY * imageHeight;
    fontSize = relativeFontSize * imageWidth;
  }


  Map<String, dynamic> toJson(double imageWidth,double imageHeight) {
    return {
      "title": text,
      "left": x/imageWidth,
      "top": y/imageHeight,
      "fontSize": fontSize/imageWidth,
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




