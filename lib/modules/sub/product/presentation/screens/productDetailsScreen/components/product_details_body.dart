import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../../app/utils/routes_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class ProductDetailsBody extends StatelessWidget {
  final bool showTitle;
  const ProductDetailsBody({Key? key, required this.showTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p25.w,
          vertical: AppPadding.p20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              data: '\$' '1000',
            ),
            Visibility(
              visible: !showTitle,
              child: Padding(
                padding: EdgeInsets.only(top: AppPadding.p5.h),
                child: CustomText(
                  data: 'product name',
                  fontSize: AppSize.s22.sp,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                CustomText(data: AppStrings.selectColor.tr()),
                Padding(
                  padding: EdgeInsets.only(top: AppPadding.p5.h),
                  child: Row(
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: AppSize.s30,
                        height: AppSize.s30,
                        margin: EdgeInsets.only(right: AppPadding.p10.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(AppSize.s10.r),
                        ),
                        child: index == 0 ? const Icon(Icons.check) : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                CustomText(data: AppStrings.selectSize.tr()),
                Padding(
                  padding: EdgeInsets.only(top: AppPadding.p15.h),
                  child: Row(
                    children: List.generate(
                      5,
                      (index) => index == 0
                          ? ClipRect(
                              child: Banner(
                                message: '',
                                location: BannerLocation.bottomEnd,
                                child: _itemSizeWidget(context, 'XL'),
                              ),
                            )
                          : _itemSizeWidget(context, 'XL'),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const CustomText(
              data:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: CustomText(data: AppStrings.review.tr()),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p5.w),
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: AppSize.s20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.s5.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => NavigationHelper.pushNamed(
                    context,
                    Routes.productReviewRoute,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: AppSize.s20,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _itemSizeWidget(BuildContext context, String data) => Container(
        width: AppSize.s30,
        height: AppSize.s30,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: AppPadding.p10.w),
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
