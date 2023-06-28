import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/skeleton.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../../sub/product/presentation/widgets/product_widget.dart';
import '../../../../sub/product/presentation/widgets/skeleton_product_widget.dart';

class BestSellerProductWidget extends StatelessWidget {
  final Status bestSellerStatus;
  final List<Product> bestSellerProds;
  const BestSellerProductWidget({
    Key? key,
    required this.bestSellerStatus,
    required this.bestSellerProds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading =
        bestSellerStatus == Status.loading || bestSellerStatus == Status.sleep;
    return Column(
      children: [
        isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(
                      height: AppSize.s12.h,
                      width: AppSize.s80.w,
                      borderRadius: BorderRadius.circular(AppSize.s5.r),
                    ),
                    Skeleton(
                      height: AppSize.s12.h,
                      width: AppSize.s60.w,
                      borderRadius: BorderRadius.circular(AppSize.s5.r),
                    ),
                  ],
                ),
              )
            : Visibility(
                visible: bestSellerProds.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.p10.h,
                  ),
                  child: Row(
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
                          arguments: ProductsParmeters(
                            productMode: ProductMode.bestSellerProds,
                            title: AppStrings.bestSelling.tr(),
                          ),
                        ),
                        child: CustomText(
                          data: AppStrings.seeAll.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        CustomIntrinsicGridView(
          physics: const NeverScrollableScrollPhysics(),
          direction: Axis.vertical,
          horizontalSpace: AppSize.s10.w,
          verticalSpace: AppSize.s10.h,
          children: List.generate(
            isLoading ? 6 : bestSellerProds.length,
            (index) => SizedBox(
              width: 1.sw / 2,
              child: isLoading
                  ? const SkeletonProductWidget()
                  : ProductWidget(
                      product: bestSellerProds[index],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
