import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      color: ColorManager.kGrey.withOpacity(0.3),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s15.r),
          topRight: Radius.circular(AppSize.s15.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p25.w,
          vertical: AppPadding.p15.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              data: AppStrings.quantity.tr(),
            ),
            SizedBox(height: AppSize.s10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(AppSize.s10.r),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        data: '10',
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                        color: theme.canvasColor,
                      ),
                    ),
                    VerticalDivider(
                      color: theme.canvasColor,
                      thickness: 1,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            splashRadius: AppSize.s25.r,
                            icon: SvgPicture.asset(
                              IconAssets.add,
                              color: theme.canvasColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            splashRadius: AppSize.s25.r,
                            icon: SvgPicture.asset(
                              IconAssets.subtrack,
                              color: theme.canvasColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSize.s10.h),
            CustomElevatedButton(
              color: theme.canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10.r),
              ),
              padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
              onPressed: () {},
              child: CustomText(
                data: AppStrings.addToCart.tr(),
                color: theme.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
