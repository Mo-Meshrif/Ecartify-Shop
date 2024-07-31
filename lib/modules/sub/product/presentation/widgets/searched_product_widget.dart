import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/helper/extensions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/product.dart';
import '../controller/product_bloc.dart';

class SearchedProductWidget extends StatelessWidget {
  const SearchedProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.read<ProductBloc>().add(
              UpdateProductDetailsEvent(
                product: product,
              ),
            );
        NavigationHelper.pushNamedAndRemoveUntil(
          context,
          Routes.productDetailsRoute,
          (route) => route.isFirst,
        );
      },
      borderRadius: BorderRadius.circular(AppSize.s15.r),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(AppSize.s10.r),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorManager.kGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSize.s15.r),
              ),
              margin: const EdgeInsets.all(AppPadding.p10),
              child: Center(
                child: ImageBuilder(
                  height: AppSize.s120.h,
                  fit: BoxFit.contain,
                  imageUrl: product.image,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: product.name,
                    maxLines: 2,
                    color: theme.canvasColor,
                  ),
                  SizedBox(height: AppSize.s5.h),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_half,
                          size: AppSize.s20,
                          color: theme.canvasColor,
                        ),
                        SizedBox(width: AppSize.s10.w),
                        CustomText(
                          data: product.avRateValue.toStringAsFixed(2),
                          color: theme.canvasColor,
                        ),
                        SizedBox(width: AppSize.s5.w),
                        VerticalDivider(
                          color: ColorManager.kGrey.withOpacity(0.3),
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            AppPadding.p5,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.kGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppSize.s10.r),
                          ),
                          child: CustomText(
                            data: product.soldNum.toString() +
                                ' ' +
                                AppStrings.sold.tr(),
                            color: theme.canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.s5.h),
                  Row(
                    children: [
                      CustomText(
                        data: '\$' + product.price.reductionStringNumber(context),
                        color: theme.canvasColor,
                      ),
                      Visibility(
                        visible: product.lastPrice.isNotEmpty,
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            CustomText(
                              data: '\$' + product.lastPrice.reductionStringNumber(context),
                              color: ColorManager.kRed,
                              textDecoration: TextDecoration.lineThrough,
                              decorationColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
