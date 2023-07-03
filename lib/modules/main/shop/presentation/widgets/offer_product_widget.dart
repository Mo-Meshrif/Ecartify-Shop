import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/skeleton.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../../sub/product/presentation/widgets/product_widget.dart';
import '../../../../sub/product/presentation/widgets/skeleton_product_widget.dart';

class OfferProductWidget extends StatelessWidget {
  final Status offerProdStatus;
  final List<Product> offerProds;
  const OfferProductWidget({
    Key? key,
    required this.offerProdStatus,
    required this.offerProds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool arabic = context.locale == AppConstants.arabic;
    bool isLoading =
        offerProdStatus == Status.loading || offerProdStatus == Status.sleep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                visible: offerProds.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(top: AppPadding.p10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          data: AppStrings.exclusiveOffer.tr(),
                          fontSize: AppSize.s22.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => NavigationHelper.pushNamed(
                          context,
                          Routes.tempProductListRoute,
                          arguments: ProductsParmeters(
                            productMode: ProductMode.offerProds,
                            title: AppStrings.exclusiveOffer.tr(),
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
        SizedBox(height: AppSize.s10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: List.generate(
                isLoading ? 5 : offerProds.length,
                (index) => Container(
                  width: 1.sw / 2.2,
                  margin: arabic
                      ? EdgeInsets.only(left: AppPadding.p10.w)
                      : EdgeInsets.only(right: AppPadding.p10.w),
                  child: isLoading
                      ? const SkeletonProductWidget()
                      : ProductWidget(product: offerProds[index]),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
