import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/helper_functions.dart';
import '../../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/constants_manager.dart';
import '../../../../../../../app/utils/routes_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../../../main/auth/domain/entities/user.dart';
import '../../../../domain/entities/product.dart';

class ProductDetailsBody extends StatefulWidget {
  final Product product;
  final bool showTitle;
  const ProductDetailsBody({
    Key? key,
    required this.showTitle,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  late bool arabic = context.locale == AppConstants.arabic;
  int selectedColorIndex = 0, selectedSizeIndex = 0;
  @override
  Widget build(BuildContext context) => Padding(
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
                  data: '\$' + widget.product.price,
                ),
                Visibility(
                  visible: widget.product.lastPrice.isNotEmpty,
                  child: Row(
                    children: [
                      SizedBox(width: AppSize.s10.w),
                      CustomText(
                        data: '\$' + widget.product.lastPrice,
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
              visible: !widget.showTitle,
              child: Padding(
                padding: EdgeInsets.only(top: AppPadding.p5.h),
                child: CustomText(
                  data: widget.product.name,
                  fontSize: AppSize.s22.sp,
                ),
              ),
            ),
            Visibility(
              visible: widget.product.color.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  CustomText(data: AppStrings.selectColor.tr()),
                  Padding(
                    padding: EdgeInsets.only(top: AppPadding.p5.h),
                    child: Row(
                      children: List.generate(
                        widget.product.color.length,
                        (index) {
                          String color = widget.product.color[index].replaceAll(
                            '#',
                            '0xff',
                          );
                          var convertedColor = Color(int.parse(color));
                          return GestureDetector(
                            onTap: () => setState(
                              () => selectedColorIndex = index,
                            ),
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
                                      color: convertedColor.computeLuminance() >
                                              0.5
                                          ? ColorManager.kBlack
                                          : ColorManager.kWhite,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.product.size.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  CustomText(data: AppStrings.selectSize.tr()),
                  Padding(
                    padding: EdgeInsets.only(top: AppPadding.p15.h),
                    child: Row(
                      children: List.generate(
                        widget.product.size.length,
                        (index) => GestureDetector(
                          onTap: () => setState(
                            () => selectedSizeIndex = index,
                          ),
                          child: index == selectedSizeIndex
                              ? ClipRect(
                                  child: Banner(
                                    message: '',
                                    location: BannerLocation.bottomEnd,
                                    child: _itemSizeWidget(
                                      context,
                                      arabic,
                                      widget.product.size[index],
                                    ),
                                  ),
                                )
                              : _itemSizeWidget(
                                  context,
                                  arabic,
                                  widget.product.size[index],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            CustomText(
              data: widget.product.description,
            ),
            const Divider(),
            widget.product.avRateValue == 0
                ? CustomElevatedButton(
                    onPressed: () {
                      AuthUser user = HelperFunctions.getSavedUser();
                      HelperFunctions.addReview(
                        context,
                        widget.product,
                        user,
                        fromDetails: true,
                      );
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
                        data: widget.product.avRateValue.toStringAsFixed(2),
                      ),
                      SizedBox(width: AppSize.s10.w),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => NavigationHelper.pushNamed(
                          context,
                          Routes.productReviewRoute,
                          arguments: widget.product,
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
  Widget _itemSizeWidget(BuildContext context, bool arabic, String data) =>
      Container(
        width: AppSize.s30,
        height: AppSize.s30,
        alignment: Alignment.center,
        margin: arabic
            ? EdgeInsets.only(left: AppPadding.p10.w)
            : EdgeInsets.only(right: AppPadding.p10.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(
            AppSize.s10.r,
          ),
        ),
        child: CustomText(data: data),
      );
}
