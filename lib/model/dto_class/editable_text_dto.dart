class EditableTextDTO{
  String text;
  double xPercent;
  double yPercent;
  double fontSizePercent;
  String color;
  String fontWeight;

  EditableTextDTO({
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.fontSizePercent,
    required this.xPercent,
    required this.yPercent
});

  Map<String, dynamic> toJson(){
    return {
      "text":text,
      "xPercent":xPercent,
      "yPercent":yPercent,
      "fontSizePercent":fontSizePercent,
      "color":color,
      "fontWeight":fontWeight
    };
  }

  factory EditableTextDTO.fromJson(Map<String,dynamic> json){
    return EditableTextDTO(
        text: json["text"],
        xPercent: (json['xPercent'] as num).toDouble(),
        yPercent: (json['yPercent'] as num).toDouble(),
        fontSizePercent: (json['fontSizePercent'] as num).toDouble(),
        color: json['color'],
        fontWeight: json['fontWeight']);
  }

}