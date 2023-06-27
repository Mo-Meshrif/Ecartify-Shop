import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  final double? height, width;
  final Color? baseColor, highlightColor;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey[300]!,
        highlightColor: highlightColor ?? Colors.grey[100]!,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: baseColor ?? Colors.grey[300]!,
          ),
        ),
      );
}
