import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class FavouriteItem extends StatelessWidget {
  const FavouriteItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(AppSize.s15.r),
        onTap: () {},
        child: Card(
          color: ColorManager.kGrey.withOpacity(0.3),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s15.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppSize.s40.r,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: ImageBuilder(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/ecartify-shop.appspot.com/o/Products%2F940a86.png?alt=media&token=cc80f6a0-f783-4497-b8fb-dc338d5b0097',
                    height: AppSize.s60.h,
                  ),
                ),
                SizedBox(width: AppSize.s15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        data: 'a',
                        maxLines: 2,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_half,
                              size: AppSize.s20,
                            ),
                            SizedBox(width: AppSize.s10.w),
                            CustomText(
                              data: 0.0.toStringAsFixed(2),
                            ),
                            SizedBox(width: AppSize.s5.w),
                            VerticalDivider(
                              color: ColorManager.kGrey.withOpacity(0.3),
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppPadding.p5),
                              decoration: BoxDecoration(
                                color: ColorManager.kGrey.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.circular(AppSize.s10.r),
                              ),
                              child: CustomText(
                                data:
                                    10.toString() + ' ' + AppStrings.sold.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h),
                      Row(
                        children: [
                          const CustomText(
                            data: '\$' '100',
                          ),
                          Row(
                            children: [
                              SizedBox(width: AppSize.s10.w),
                              CustomText(
                                data: '\$' '200',
                                color: ColorManager.kRed,
                                textDecoration: TextDecoration.lineThrough,
                                decorationColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: AppSize.s5.h),
                    ],
                  ),
                ),
                SizedBox(width: AppSize.s10.w),
                IconButton(
                  splashRadius: AppSize.s30.r,
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: ColorManager.kRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
