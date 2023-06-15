import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s15.r),
            child: Container(
              color: ColorManager.kGrey.withOpacity(0.3),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      onPressed: () {},
                      icon: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: ColorManager.kBlack,
                        child: Padding(
                          padding: EdgeInsets.only(top: AppPadding.p5.h),
                          child: SvgPicture.asset(
                            IconAssets.favourite,
                            fit: BoxFit.fitHeight,
                            width: AppSize.s20.w,
                            color: ColorManager.kWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/ecartify-shop.appspot.com/o/beats-headphones.png?alt=media&token=edb67fbd-404f-492f-a519-e0dffbf5a5bc',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSize.s5.h),
          const CustomText(
            data: 'product name',
          ),
          SizedBox(height: AppSize.s5.h),
          Row(
            children: [
              const Icon(
                Icons.star_half,
                size: AppSize.s20,
              ),
              SizedBox(width: AppSize.s10.w),
              const CustomText(
                data: '4.6',
              ),
              const VerticalDivider(),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p5),
                    decoration: BoxDecoration(
                      color: ColorManager.kGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppSize.s10.r),
                    ),
                    child: CustomText(
                      data: '6.983' ' ' + AppStrings.sold.tr(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s5.h),
          const CustomText(
            data: '\$' '1000',
          ),
          SizedBox(height: AppSize.s5.h),
        ],
      ),
    );
  }
}
