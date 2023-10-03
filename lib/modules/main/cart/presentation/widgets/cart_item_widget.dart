import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/color_selector_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/common/widgets/size_selector_widget.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_item_statistics.dart';
import '../controller/cart_bloc.dart';

class CartItemWidget extends StatefulWidget {
  final bool disableGestures;
  final CartItem cartItem;
  const CartItemWidget({
    Key? key,
    required this.cartItem,
    this.disableGestures = false,
  }) : super(key: key);

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late var theme = Theme.of(context);
  List<String> colorList = [], sizeList = [];
  CartItemStatistics? statistics;
  String? selectedColor, selectedSize;
  String quantity = '0';
  int colorIndex = -1, sizeIndex = -1;

  @override
  void initState() {
    setState(() {
      statistics = widget.cartItem.statistics[0];
      quantity = statistics!.quantity;
      selectedColor = statistics!.color;
      selectedSize = statistics!.size;
      colorIndex = widget.cartItem.statistics.indexWhere(
        (item) => item.color.isNotEmpty,
      );
      sizeIndex = widget.cartItem.statistics.indexWhere(
        (item) => item.size.isNotEmpty,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorList = widget.cartItem.statistics.map((e) => e.color).toSet().toList();
    sizeList = widget.cartItem.statistics.map((e) => e.size).toSet().toList();
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(AppSize.s10.r),
      ),
      child: Column(
        children: [
          SizedBox(height: AppSize.s5.h),
          ListTile(
            leading: CircleAvatar(
              radius: AppSize.s40.r,
              backgroundColor: ColorManager.kGrey.withOpacity(0.3),
              child: ImageBuilder(
                imageUrl: widget.cartItem.product!.image,
              ),
            ),
            title: CustomText(
              data: widget.cartItem.product!.name,
              maxLines: 2,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: AppPadding.p5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  colorIndex == -1
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: widget.disableGestures
                                  ? ColorManager.kGrey.withOpacity(0.3)
                                  : null,
                            ),
                            Row(
                              children: [
                                CustomText(
                                  data: AppStrings.colors.tr() + ' : ',
                                ),
                                SizedBox(width: AppSize.s5.w),
                                Expanded(
                                  child: ColorSelectorWidget(
                                    colorList: colorList,
                                    selectedColor: selectedColor,
                                    getSelectedColor: (color) => setState(() {
                                      selectedColor = color;
                                      int index = widget.cartItem.statistics
                                          .indexWhere((element) =>
                                              element.color == selectedColor &&
                                              element.size == selectedSize);
                                      if (index > -1) {
                                        statistics =
                                            widget.cartItem.statistics[index];
                                        quantity = statistics!.quantity;
                                      } else {
                                        statistics = null;
                                        quantity = '0';
                                      }
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  sizeIndex == -1
                      ? const SizedBox()
                      : Padding(
                          padding: colorIndex == -1
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: AppPadding.p5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: widget.disableGestures
                                    ? ColorManager.kGrey.withOpacity(0.3)
                                    : null,
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    data: AppStrings.sizes.tr() + ' : ',
                                  ),
                                  SizedBox(width: AppSize.s5.w),
                                  Expanded(
                                    child: SizeSelectorWidget(
                                      sizeList: sizeList,
                                      selectedSize: selectedSize,
                                      getSelectedSize: (size) => setState(() {
                                        selectedSize = size;
                                        int index = widget.cartItem.statistics
                                            .indexWhere((element) =>
                                                element.color ==
                                                    selectedColor &&
                                                element.size == selectedSize);
                                        if (index > -1) {
                                          statistics =
                                              widget.cartItem.statistics[index];
                                          quantity = statistics!.quantity;
                                        } else {
                                          statistics = null;
                                          quantity = '0';
                                        }
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSize.s10.h),
          Card(
            margin: EdgeInsets.zero,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSize.s10.r),
                bottomRight: Radius.circular(AppSize.s10.r),
              ),
            ),
            child: quantity == '0'
                ? SizedBox(
                    width: 1.sw,
                    child: TextButton(
                      onPressed: () {
                        if (widget.cartItem.product!.storeAmount >
                            HelperFunctions.refactorCartItemLength(
                                [widget.cartItem])) {
                          setState(() {
                            quantity = '1';
                            statistics = CartItemStatistics(
                              prodId: widget.cartItem.product!.id,
                              color: selectedColor ?? '',
                              size: selectedSize ?? '',
                              quantity: quantity,
                            );
                          });
                          sl<CartBloc>().add(
                            AddItemToCartEvent(
                              prodIsInCart: true,
                              product: widget.cartItem.product!,
                              statistics: CartItemStatistics(
                                prodId: widget.cartItem.product!.id,
                                color: selectedColor ?? '',
                                size: selectedSize ?? '',
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
                                ' ' '${widget.cartItem.product!.storeAmount}',
                          );
                        }
                      },
                      child: CustomText(
                        data: AppStrings.addToCart.tr(),
                        color: theme.canvasColor,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                widget.disableGestures ? AppPadding.p25.w : 0,
                            vertical:
                                widget.disableGestures ? AppPadding.p10.h : 0,
                          ),
                          child: Row(
                            children: widget.disableGestures
                                ? [
                                    Expanded(
                                      child: CustomText(
                                        data: widget.cartItem.product!.price,
                                        fontSize: AppSize.s20.sp,
                                        color: theme.canvasColor,
                                      ),
                                    ),
                                    CustomText(
                                      data: quantity,
                                      fontSize: AppSize.s25.sp,
                                      color: theme.canvasColor,
                                    )
                                  ]
                                : [
                                    SizedBox(width: AppSize.s25.w),
                                    CustomText(
                                      data: widget.cartItem.product!.price,
                                      fontSize: AppSize.s20.sp,
                                      color: theme.canvasColor,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (widget.cartItem.product!
                                                      .storeAmount >
                                                  HelperFunctions
                                                      .refactorCartItemLength(
                                                          [widget.cartItem])) {
                                                setState(() {
                                                  statistics = statistics!.copyWith(
                                                      '${int.parse(statistics!.quantity) + 1}');
                                                  quantity =
                                                      statistics!.quantity;
                                                });
                                                sl<CartBloc>().add(
                                                  ChangeQuantityEvent(
                                                    statistics: statistics!,
                                                  ),
                                                );
                                              } else {
                                                HelperFunctions.showSnackBar(
                                                  context,
                                                  AppStrings.productQuantity
                                                          .tr() +
                                                      ' ' +
                                                      AppStrings
                                                          .quantityCondition
                                                          .tr() +
                                                      ' '
                                                          '${widget.cartItem.product!.storeAmount}',
                                                );
                                              }
                                            },
                                            splashRadius: AppSize.s25.r,
                                            icon: SvgPicture.asset(
                                              IconAssets.add,
                                              color: theme.canvasColor,
                                            ),
                                          ),
                                          CustomText(
                                            data: quantity,
                                            fontSize: AppSize.s25.sp,
                                            color: theme.canvasColor,
                                          ),
                                          Visibility(
                                            visible: widget.cartItem.statistics
                                                            .length ==
                                                        1 &&
                                                    quantity == '1'
                                                ? false
                                                : true,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  statistics = statistics!.copyWith(
                                                      '${int.parse(statistics!.quantity) - 1}');
                                                  quantity =
                                                      statistics!.quantity;
                                                });
                                                sl<CartBloc>().add(
                                                  ChangeQuantityEvent(
                                                    statistics: statistics!,
                                                  ),
                                                );
                                                if (quantity == '0') {
                                                  setState(
                                                    () {
                                                      statistics = widget
                                                          .cartItem.statistics
                                                          .firstWhere(
                                                        (e) =>
                                                            e.color !=
                                                                statistics!
                                                                    .color ||
                                                            e.size !=
                                                                statistics!
                                                                    .size,
                                                      );
                                                      selectedColor =
                                                          statistics!.color;
                                                      selectedSize =
                                                          statistics!.size;
                                                      quantity =
                                                          statistics!.quantity;
                                                    },
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
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      widget.disableGestures
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () => sl<CartBloc>().add(
                                DeleteItemEvent(
                                  prodId: widget.cartItem.prodId,
                                ),
                              ),
                              splashRadius: AppSize.s25.r,
                              icon: Icon(
                                Icons.delete,
                                color: ColorManager.kRed,
                              ),
                            )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
