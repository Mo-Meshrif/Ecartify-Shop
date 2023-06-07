import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextStyle? textStyle;

  const CustomText({
    Key? key,
    required this.data,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        data,
        style: textStyle ??
            TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
      );
}
