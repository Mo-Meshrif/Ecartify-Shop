import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/common/widgets/color_selector_widget.dart';
import '../../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/common/widgets/size_selector_widget.dart';
import '../../../../../../../app/helper/helper_functions.dart';
import '../../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/routes_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../../../main/auth/domain/entities/user.dart';
import '../../../../domain/entities/product.dart';

class ProductDetailsBody extends StatelessWidget {
  final Product product;
  final bool showTitle;
  final void Function(String) getSelectedColor, getSelectedSize;
  const ProductDetailsBody({
    Key? key,
    required this.showTitle,
    required this.product,
    required this.getSelectedColor,
    required this.getSelectedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mark = HelperFunctions.getCurrencyMark();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p25.w,
        vertical: AppPadding.p20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSize.s10.h),
          Row(
            children: [
              CustomText(
                data: product.price + ' ' + mark,
              ),
              Visibility(
                visible: product.lastPrice.isNotEmpty,
                child: Row(
                  children: [
                    SizedBox(width: AppSize.s10.w),
                    CustomText(
                      data: product.lastPrice + ' ' + mark,
                      color: ColorManager.kRed,
                      textDecoration: TextDecoration.lineThrough,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: !showTitle,
            child: Padding(
              padding: EdgeInsets.only(top: AppPadding.p5.h),
              child: CustomText(
                data: product.name,
                fontSize: AppSize.s22.sp,
              ),
            ),
          ),
          Visibility(
            visible: product.color.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                CustomText(data: AppStrings.selectColor.tr()),
                Padding(
                  padding: EdgeInsets.only(top: AppPadding.p5.h),
                  child: ColorSelectorWidget(
                    colorList: product.color,
                    getSelectedColor: getSelectedColor,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: product.size.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                CustomText(data: AppStrings.selectSize.tr()),
                Padding(
                  padding: EdgeInsets.only(top: AppPadding.p15.h),
                  child: SizeSelectorWidget(
                    sizeList: product.size,
                    getSelectedSize: getSelectedSize,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Visibility(
            visible: product.description.isNotEmpty,
            child: Column(
              children: [
                CustomText(
                  data: product.description,
                ),
                const Divider()
              ],
            ),
          ),
          product.avRateValue == 0
              ? CustomElevatedButton(
                  onPressed: () {
                    AuthUser? user = HelperFunctions.getSavedUser();
                    if (user != null) {
                      HelperFunctions.addProductReview(
                        context,
                        product,
                        user,
                        fromDetails: true,
                      );
                    } else {
                      HelperFunctions.showSnackBar(
                        context,
                        AppStrings.operationFailed.tr(),
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                  child: CustomText(
                    data: AppStrings.writeReview.tr(),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: CustomText(data: AppStrings.review.tr()),
                    ),
                    const Icon(
                      Icons.star_half,
                      size: AppSize.s20,
                    ),
                    SizedBox(width: AppSize.s10.w),
                    CustomText(
                      data: product.avRateValue.toStringAsFixed(2),
                    ),
                    SizedBox(width: AppSize.s10.w),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => NavigationHelper.pushNamed(
                        context,
                        Routes.productReviewRoute,
                        arguments: product,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: AppSize.s20,
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
