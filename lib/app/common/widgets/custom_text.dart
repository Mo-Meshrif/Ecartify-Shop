import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final Color? color, decorationColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextStyle? textStyle;
  final TextDecoration? textDecoration;
  final int? maxLines;

  const CustomText({
    Key? key,
    required this.data,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textStyle,
    this.textDecoration,
    this.maxLines,
    this.decorationColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        data,
        maxLines: maxLines,
        style: textStyle ??
            TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              decoration: textDecoration,
              decorationColor: decorationColor,
            ),
      );
}
