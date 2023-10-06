import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../domain/entities/product.dart';
import '../controller/product_bloc.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mark = HelperFunctions.getCurrencyMark();
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSize.s15.r,
        ),
      ),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(15.r),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s15.r),
                child: Container(
                  color: ColorManager.kGrey.withOpacity(0.3),
                  child: Stack(
                    children: [
                      Center(
                        child: ImageBuilder(
                          height: AppSize.s205.h,
                          fit: BoxFit.contain,
                          imageUrl: product.image,
                        ),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          int index = state.cartItems.indexWhere(
                            (e) => e.prodId == product.id,
                          );
                          return Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: index > -1
                                ? IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: AppSize.s30.r,
                                    onPressed: () => sl<CartBloc>().add(
                                      DeleteItemEvent(
                                        prodId: product.id,
                                      ),
                                    ),
                                    icon: CircleAvatar(
                                      radius: AppSize.s20.r,
                                      backgroundColor: ColorManager.kBlack,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: AppPadding.p5.h,
                                        ),
                                        child: SvgPicture.asset(
                                          IconAssets.cart,
                                          width: AppSize.s20.w,
                                          color: ColorManager.kRed,
                                        ),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: AppSize.s30.r,
                                    onPressed: () =>
                                        HelperFunctions.handleFavFun(
                                      context,
                                      product,
                                    ),
                                    icon: CircleAvatar(
                                      radius: AppSize.s20.r,
                                      backgroundColor: ColorManager.kBlack,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: AppPadding.p5.h,
                                        ),
                                        child: SvgPicture.asset(
                                          IconAssets.favourite,
                                          width: AppSize.s20.w,
                                          color: product.isFavourite
                                              ? ColorManager.kRed
                                              : ColorManager.kWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s5.h),
              CustomText(
                data: product.name,
                maxLines: 2,
              ),
              SizedBox(height: AppSize.s5.h),
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
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppPadding.p5),
                          decoration: BoxDecoration(
                            color: ColorManager.kGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppSize.s10.r),
                          ),
                          child: CustomText(
                            data: product.soldNum.toString() +
                                ' ' +
                                AppStrings.sold.tr(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.s5.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: product.price + ' ' + mark + '  ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    product.lastPrice.isNotEmpty
                        ? TextSpan(
                            children: [
                              TextSpan(
                                text: product.lastPrice,
                                style: TextStyle(
                                  color: ColorManager.kRed,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: ' ' + mark,
                                style: TextStyle(
                                  color: ColorManager.kRed,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          )
                        : const WidgetSpan(child: SizedBox())
                  ],
                ),
              ),
              SizedBox(height: AppSize.s5.h),
            ],
          ),
        ),
      ),
    );
  }
}
