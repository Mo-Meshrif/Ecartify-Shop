import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_manager.dart';
import '../../utils/values_manager.dart';

class ColorSelectorWidget extends StatefulWidget {
  final List<String> colorList;
  final String? selectedColor;
  final void Function(String color) getSelectedColor;
  const ColorSelectorWidget({
    Key? key,
    required this.colorList,
    required this.getSelectedColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  State<ColorSelectorWidget> createState() => _ColorSelectorWidgetState();
}

class _ColorSelectorWidgetState extends State<ColorSelectorWidget> {
  int selectedColorIndex = 0;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: AppSize.s30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.colorList.length,
          itemBuilder: (context, index) {
            String color = widget.colorList[index].replaceAll(
              '#',
              '0xff',
            );
            var convertedColor = Color(int.parse(color));
            bool isMark = widget.selectedColor != null
                ? widget.selectedColor == widget.colorList[index]
                : index == selectedColorIndex;
            return GestureDetector(
              onTap: () {
                setState(
                  () => selectedColorIndex = index,
                );
                widget.getSelectedColor(widget.colorList[index]);
              },
              child: Container(
                width: AppSize.s30,
                decoration: BoxDecoration(
                  color: convertedColor,
                  border: Border.all(
                    color: convertedColor.computeLuminance() > 0.5
                        ? ColorManager.kBlack
                        : ColorManager.kWhite,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppSize.s10.r,
                  ),
                ),
                child: isMark
                    ? Icon(
                        Icons.check,
                        color: convertedColor.computeLuminance() > 0.5
                            ? ColorManager.kBlack
                            : ColorManager.kWhite,
                      )
                    : null,
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            width: AppSize.s10.w,
          ),
        ),
      );
}
