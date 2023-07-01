import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/presentation/controller/product_bloc.dart';

class FavouriteItem extends StatelessWidget {
  final Product product;
  const FavouriteItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(AppSize.s15.r),
        onTap: () {
          context.read<ProductBloc>().add(
                UpdateProductDetailsEvent(
                  product: product,
                ),
              );
          NavigationHelper.pushNamed(
            context,
            Routes.productDetailsRoute,
          );
        },
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
                    imageUrl: product.image,
                    height: AppSize.s60.h,
                  ),
                ),
                SizedBox(width: AppSize.s15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data: product.name,
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
                              data: product.avRateValue.toStringAsFixed(2),
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
                                data: product.soldNum.toString() +
                                    ' ' +
                                    AppStrings.sold.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h),
                      Row(
                        children: [
                          CustomText(
                            data: '\$' + product.price,
                          ),
                          Visibility(
                            visible: product.lastPrice.isNotEmpty,
                            child: Row(
                              children: [
                                SizedBox(width: AppSize.s10.w),
                                CustomText(
                                  data: '\$' + product.lastPrice,
                                  color: ColorManager.kRed,
                                  textDecoration: TextDecoration.lineThrough,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
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
                  onPressed: () => HelperFunctions.handleFavFun(
                    context,
                    product,
                  ),
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
