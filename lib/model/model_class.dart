class EditableTextItem {
  String text;
  double x;
  double y;
  double fontSize;

  double relativeX;
  double relativeY;
 // double relativeFontSize;

  String colorHex;
  String fontWeight;

  EditableTextItem({
    required this.text,
    required this.x,
    required this.y,
    this.fontSize = 18,
    this.relativeX = 0,
    this.relativeY = 0,
    //this.relativeFontSize = 0,
    this.colorHex = '000000',
    this.fontWeight = 'FontWeight.w400',
  });

  void updateRelative(double imageWidth, double imageHeight) {
    relativeX = x / imageWidth;
    relativeY = y / imageHeight;
    //relativeFontSize = fontSize / imageWidth;
  }

  void updateAbsolute(double imageWidth, double imageHeight) {
    x = relativeX * imageWidth;
    y = relativeY * imageHeight;
   //fontSize = relativeFontSize * imageWidth;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": text,
      "left": x,
      "top": y,
      "fontSize": fontSize.toStringAsFixed(1),
      "Color": colorHex,
      "fontWeight": fontWeight,
      //"relativeX": relativeX,
      //"relativeY": relativeY,
      //"relativeFontSize": relativeFontSize,
    };
  }

  factory EditableTextItem.fromJson(Map<String, dynamic> json) {
    return EditableTextItem(
      text: json['text'],
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      fontSize: (json['fontSize'] as num).toDouble(),
      colorHex: json['colorHex'],
      fontWeight: json['fontWeight'],
      relativeX: (json['relativeX'] ?? 0).toDouble(),
      relativeY: (json['relativeY'] ?? 0).toDouble(),
      //relativeFontSize: (json['relativeFontSize'] ?? 0).toDouble(),
    );
  }
}
// final List<Map<String, dynamic>> jsonData = [
//   {
//     "title": "name 1",
//     "titleX": 30.0,
//     "titleY": 399.0,
//     "title_size": 17,
//     "title_font": "Roboto",
//     "title_color": "000000",
//     "fontWeight": "FontWeight.w400"
//   },
//   {
//     "title": "name 2",
//     "titleX": 50.0,
//     "titleY": 430.0,
//     "title_size": 18,
//     "title_font": "Roboto",
//     "title_color": "111111",
//     "fontWeight": "FontWeight.w500"
//   },
//   {
//     "title": "name 3",
//     "titleX": 70.0,
//     "titleY": 460.0,
//     "title_size": 16,
//     "title_font": "Roboto",
//     "title_color": "222222",
//     "fontWeight": "FontWeight.w600"
//   },
// ];


