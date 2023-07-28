import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/helper_functions.dart';
import '../../../../../../../app/services/services_locator.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../../../main/cart/domain/entities/cart_item_statistics.dart';
import '../../../../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../../../domain/entities/product.dart';

class AddToCartWidget extends StatelessWidget {
  final Product product;
  final String selectedColor, selectedSize;
  const AddToCartWidget(
      {Key? key,
      required this.product,
      required this.selectedColor,
      required this.selectedSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      color: ColorManager.kGrey.withOpacity(0.3),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s15.r),
          topRight: Radius.circular(AppSize.s15.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p25.w,
          vertical: AppPadding.p15.h,
        ),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int index = state.cartItems.indexWhere(
              (item) => item.prodId == product.id,
            );
            var innerIndex = index == -1
                ? -1
                : state.cartItems[index].statistics.indexWhere((element) =>
                    element.color == selectedColor &&
                    element.size == selectedSize);
            CartItemStatistics? statistics = innerIndex == -1
                ? null
                : state.cartItems[index].statistics[innerIndex];
            String quantity = statistics == null ? '1' : statistics.quantity;
            return StatefulBuilder(
              builder: (context, innerState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: AppStrings.quantity.tr(),
                  ),
                  SizedBox(height: AppSize.s10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(AppSize.s10.r),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              data: quantity,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: theme.canvasColor,
                            ),
                          ),
                          VerticalDivider(
                            color: theme.canvasColor,
                            thickness: 1,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (product.storeAmount >
                                        (index == -1
                                            ? int.parse(quantity)
                                            : HelperFunctions
                                                .refactorCartItemLength([
                                                state.cartItems[index]
                                              ]))) {
                                      int intQuantity = int.parse(quantity);
                                      innerState(
                                        () {
                                          intQuantity += 1;
                                          quantity = intQuantity.toString();
                                        },
                                      );
                                      if (innerIndex > -1) {
                                        sl<CartBloc>().add(
                                          ChangeQuantityEvent(
                                            statistics: CartItemStatistics(
                                              prodId: product.id,
                                              color: selectedColor,
                                              size: selectedSize,
                                              quantity: quantity,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      HelperFunctions.showSnackBar(
                                        context,
                                        AppStrings.productQuantity.tr() +
                                            ' ' +
                                            AppStrings.quantityCondition.tr() +
                                            ' '
                                                '${product.storeAmount}',
                                      );
                                    }
                                  },
                                  splashRadius: AppSize.s25.r,
                                  icon: SvgPicture.asset(
                                    IconAssets.add,
                                    color: theme.canvasColor,
                                  ),
                                ),
                                Visibility(
                                  visible: int.parse(quantity) > 1,
                                  child: IconButton(
                                    onPressed: () {
                                      int intQuantity = int.parse(quantity);
                                      innerState(
                                        () {
                                          intQuantity -= 1;
                                          quantity = intQuantity.toString();
                                        },
                                      );
                                      if (innerIndex > -1) {
                                        sl<CartBloc>().add(
                                          ChangeQuantityEvent(
                                            statistics: CartItemStatistics(
                                              prodId: product.id,
                                              color: selectedColor,
                                              size: selectedSize,
                                              quantity: quantity,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    splashRadius: AppSize.s25.r,
                                    icon: SvgPicture.asset(
                                      IconAssets.subtrack,
                                      color: theme.canvasColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.s10.h),
                  Visibility(
                    visible: innerIndex == -1,
                    child: CustomElevatedButton(
                      color: theme.canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                      onPressed: () {
                        if (product.storeAmount > int.parse(quantity)) {
                          if (product.isFavourite) {
                            HelperFunctions.handleFavFun(
                              context,
                              product,
                            );
                          }
                          sl<CartBloc>().add(
                            AddItemToCartEvent(
                              prodIsInCart: index > -1,
                              product: product,
                              statistics: CartItemStatistics(
                                prodId: product.id,
                                color: selectedColor,
                                size: selectedSize,
                                quantity: quantity,
                              ),
                            ),
                          );
                        } else {
                          HelperFunctions.showSnackBar(
                            context,
                            AppStrings.productQuantity.tr() +
                                ' ' +
                                AppStrings.quantityCondition.tr() +
                                ' '
                                    '${product.storeAmount}',
                          );
                        }
                      },
                      child: CustomText(
                        data: AppStrings.addToCart.tr(),
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
