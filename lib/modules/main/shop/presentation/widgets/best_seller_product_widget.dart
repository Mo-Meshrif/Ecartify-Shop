import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/presentation/widgets/product_widget.dart';

class BestSellerProductWidget extends StatelessWidget {
  const BestSellerProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                data: AppStrings.bestSelling.tr(),
                fontSize: AppSize.s22.sp,
              ),
            ),
            GestureDetector(
              onTap: () => NavigationHelper.pushNamed(
                context,
                Routes.tempProductListRoute,
                arguments: false,
              ),
              child: CustomText(
                data: AppStrings.seeAll.tr(),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.s10.h),
        CustomIntrinsicGridView(
          physics: const NeverScrollableScrollPhysics(),
          direction: Axis.vertical,
          horizontalSpace: AppSize.s10.w,
          verticalSpace: AppSize.s10.h,
          children: List.generate(
            4,
            (index) => SizedBox(
              width: 1.sw / 2,
              child: const ProductWidget(),
            ),
          ),
        ),
      ],
    );
  }
}
