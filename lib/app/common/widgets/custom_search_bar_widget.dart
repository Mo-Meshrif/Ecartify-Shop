import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/strings_manager.dart';
import '../../utils/values_manager.dart';
import 'custom_text.dart';

class CustomSearchBarWidget extends StatelessWidget {
  const CustomSearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p20.w,
          vertical: AppPadding.p15.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s15.r),
          color: ColorManager.kGrey.withOpacity(0.3),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              IconAssets.search,
              color: primaryColor,
            ),
            SizedBox(width: AppPadding.p10.w),
            CustomText(
              data: AppStrings.search.tr(),
              fontSize: AppSize.s22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
