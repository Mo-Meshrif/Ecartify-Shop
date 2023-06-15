import 'package:flutter/material.dart';

class CustomIntrinsicGridView extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final int count;
  final EdgeInsets padding, margin;
  final ScrollPhysics? physics;
  final double horizontalSpace, verticalSpace;

  const CustomIntrinsicGridView({
    Key? key,
    required this.children,
    required this.direction,
    this.count = 2,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.physics,
    this.horizontalSpace = 0.0,
    this.verticalSpace = 0.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EdgeInsets childMargin = EdgeInsets.symmetric(
      vertical: verticalSpace / 2,
      horizontal: horizontalSpace / 2,
    );
    return Container(
      margin: margin,
      child: SingleChildScrollView(
        physics: physics,
        padding: padding,
        scrollDirection: direction,
        child: direction == Axis.horizontal
            ? _getHorizontalGrid(childMargin)
            : _getVerticalGrid(childMargin),
      ),
    );
  }

  Widget _getVerticalGrid(EdgeInsets childMargin) {
    return Column(
      children: [
        for (int i = 0; i < children.length;)
          IntrinsicHeight(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < count; i++, j++)
                    Expanded(
                      child: i < children.length
                          ? Container(
                              margin: childMargin,
                              child: children.elementAt(i),
                            )
                          : const Text(''),
                    ),
                ]),
          )
      ],
    );
  }

  Widget _getHorizontalGrid(EdgeInsets childMargin) {
    return Row(
      children: [
        for (int i = 0; i < children.length;)
          IntrinsicWidth(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < count; i++, j++)
                    Expanded(
                      child: i < children.length
                          ? Container(
                              margin: childMargin,
                              child: children.elementAt(i),
                            )
                          : const Text(''),
                    ),
                ]),
          )
      ],
    );
  }
}
