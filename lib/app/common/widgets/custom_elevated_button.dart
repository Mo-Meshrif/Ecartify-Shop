import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomElevatedButton extends StatelessWidget {
  final double? width;
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final void Function()? onPressed;
  const CustomElevatedButton({
    Key? key,
    this.width,
    this.color,
    this.padding,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width ?? 1.sw,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: padding,
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
}
