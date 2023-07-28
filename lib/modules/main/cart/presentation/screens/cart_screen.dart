import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loading = true;
  late var theme = Theme.of(context);
  @override
  void initState() {
    getPagetContent();
    super.initState();
  }

  getPagetContent() => sl<CartBloc>().add(
        const GetCartItems(
          cartInit: true,
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.cartStatus == Status.loading) {
              loading = true;
            } else if (state.cartStatus == Status.loaded ||
                state.cartStatus == Status.error) {
              if (loading) {
                loading = false;
              }
            }
          },
          builder: (context, state) => SafeArea(
            child: loading || state.cartItems.isEmpty
                ? Center(
                    child: loading
                        ? Lottie.asset(
                            JsonAssets.loading,
                            height: AppSize.s200,
                            width: AppSize.s200,
                          )
                        : state.cartItemsNumber > 0
                            ? const Icon(Icons.error)
                            : Lottie.asset(JsonAssets.empty),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          color: theme.canvasColor,
                          backgroundColor: theme.primaryColor,
                          onRefresh: () {
                            getPagetContent();
                            return Future.value();
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p15.w,
                              vertical: AppPadding.p10.h,
                            ),
                            itemCount: state.cartItems.length,
                            itemBuilder: (context, index) => CartItemWidget(
                              cartItem: state.cartItems[index],
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: AppSize.s10.h,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        color: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSize.s15.r),
                            topRight: Radius.circular(AppSize.s15.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p15.w,
                            vertical: AppPadding.p10.h,
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CustomText(
                                    data: AppStrings.totalPrice.tr(),
                                    color: ColorManager.kGrey,
                                  ),
                                  CustomText(
                                    data: '\$' +
                                        state.totalPrice.toStringAsFixed(2),
                                    fontSize: AppSize.s20.sp,
                                    color: theme.canvasColor,
                                  ),
                                ],
                              ),
                              SizedBox(width: AppSize.s15.w),
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () {
                                    int errorCount = 0;
                                    for (var item in state.cartItems) {
                                      int quantity = 0;
                                      for (var element in item.statistics) {
                                        quantity += int.parse(element.quantity);
                                      }
                                      if (quantity >
                                          item.product!.storeAmount) {
                                        int index = state.cartItems.indexOf(
                                          item,
                                        );
                                        errorCount += 1;

                                        HelperFunctions.showSnackBar(
                                          context,
                                          AppStrings.productQuantityNo.tr() +
                                              ' ' +
                                              '${index + 1}' +
                                              ' ' +
                                              AppStrings.quantityCondition
                                                  .tr() +
                                              ' ' +
                                              '${item.product!.storeAmount}',
                                        );
                                        break;
                                      }
                                    }
                                    if (errorCount == 0) {
                                      //TODO to checkout
                                    }
                                  },
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.s20.h,
                                  ),
                                  color: theme.canvasColor,
                                  child: CustomText(
                                    data: AppStrings.checkout.tr(),
                                    color: theme.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      );
}
