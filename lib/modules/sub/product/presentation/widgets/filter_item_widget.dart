
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/values_manager.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    Key? key,
    required this.data,
    this.isRating = false,
    required this.onTap,
    this.selected = false,
    required this.theme,
  }) : super(key: key);
  final String data;
  final ThemeData theme;
  final bool isRating, selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = selected ? theme.canvasColor : theme.primaryColor;
    Color bodyColor = selected ? theme.primaryColor : theme.canvasColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppPadding.p10.h,
        ),
        padding:  const EdgeInsets.all(AppPadding.p7),
        decoration: BoxDecoration(
          color: bodyColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(
            AppSize.s15.r,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isRating,
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: AppSize.s20,
                    color: selected ? Colors.orange : null,
                  ),
                  SizedBox(width: AppSize.s5.w),
                ],
              ),
            ),
            CustomText(
              data: data,
              color: borderColor,
              fontSize: AppSize.s17.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
