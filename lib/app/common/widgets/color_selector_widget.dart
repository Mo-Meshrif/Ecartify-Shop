import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_manager.dart';
import '../../utils/constants_manager.dart';
import '../../utils/values_manager.dart';

class ColorSelectorWidget extends StatefulWidget {
  final List<String> colorList;
  final void Function(String color) getSelectedColor;
  const ColorSelectorWidget({
    Key? key,
    required this.colorList,
    required this.getSelectedColor,
  }) : super(key: key);

  @override
  State<ColorSelectorWidget> createState() => _ColorSelectorWidgetState();
}

class _ColorSelectorWidgetState extends State<ColorSelectorWidget> {
  late bool arabic = context.locale == AppConstants.arabic;
  int selectedColorIndex = 0;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.colorList.length,
            (index) {
              String color = widget.colorList[index].replaceAll(
                '#',
                '0xff',
              );
              var convertedColor = Color(int.parse(color));
              return GestureDetector(
                onTap: () {
                  setState(
                    () => selectedColorIndex = index,
                  );
                  widget.getSelectedColor(widget.colorList[index]);
                },
                child: Container(
                  width: AppSize.s30,
                  height: AppSize.s30,
                  margin: arabic
                      ? EdgeInsets.only(left: AppPadding.p10.w)
                      : EdgeInsets.only(right: AppPadding.p10.w),
                  decoration: BoxDecoration(
                    color: convertedColor,
                    borderRadius: BorderRadius.circular(
                      AppSize.s10.r,
                    ),
                  ),
                  child: index == selectedColorIndex
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
          ),
        ),
      );
}
