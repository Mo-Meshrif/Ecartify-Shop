import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/presentation/widgets/product_widget.dart';

class OfferProductWidget extends StatelessWidget {
  const OfferProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool arabic = context.locale == AppConstants.arabic;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                data: AppStrings.exclusiveOffer.tr(),
                fontSize: AppSize.s22.sp,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: CustomText(
                data: AppStrings.seeAll.tr(),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.s10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: List.generate(
                10,
                (index) => Container(
                  width: 1.sw / 2.2,
                  margin: arabic
                      ? EdgeInsets.only(left: AppPadding.p10.w)
                      : EdgeInsets.only(right: AppPadding.p10.w),
                  child: const ProductWidget(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
