import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/color_selector_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/common/widgets/size_selector_widget.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/cart/domain/entities/cart_item.dart';
import '../../../../main/cart/domain/entities/cart_item_statistics.dart';
import '../../domain/entities/order.dart';
import 'order_status_summary_item.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.isCompleted = false,
  });

  final OrderEntity order;
  final bool isCompleted;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late var theme = Theme.of(context);
  List<String> colorList = [], sizeList = [];
  CartItemStatistics? statistics;
  String? selectedColor, selectedSize;
  String quantity = '0';
  int colorIndex = -1, sizeIndex = -1, itemIndex = 0;
  late CartItem item = widget.order.items[itemIndex];
  List<String> orderSummaryList = [
    AppStrings.underPrepare,
    AppStrings.inDelivered,
    AppStrings.delivered,
  ];
  @override
  void initState() {
    signData();
    super.initState();
  }

  signData() => setState(
        () {
          statistics = item.statistics[0];
          quantity = statistics!.quantity;
          selectedColor = statistics!.color;
          selectedSize = statistics!.size;
          colorIndex = item.statistics.indexWhere(
            (item) => item.color.isNotEmpty,
          );
          sizeIndex = item.statistics.indexWhere(
            (item) => item.size.isNotEmpty,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    colorList = item.statistics.map((e) => e.color).toSet().toList();
    sizeList = item.statistics.map((e) => e.size).toSet().toList();
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: widget.isCompleted && widget.order.rate == -1
                ? EdgeInsets.symmetric(horizontal: 10.w)
                : const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    data:
                        double.parse(widget.order.totalPrice).toStringAsFixed(2) +
                            ' ' +
                            widget.order.currency.tr(),
                    fontSize: AppSize.s20.sp,
                    color: theme.canvasColor,
                    maxLines: 2,
                  ),
                ),
                widget.isCompleted
                    ? widget.order.rate != -1
                        ? RatingBar.builder(
                            initialRating: widget.order.rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: theme.canvasColor,
                            ignoreGestures: true,
                            onRatingUpdate: (value) {},
                          )
                        : ElevatedButton(
                            onPressed: () => HelperFunctions.addOrderReview(
                                context, widget.order.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.canvasColor,
                            ),
                            child: CustomText(
                              data: AppStrings.leaveReview.tr(),
                              color: theme.primaryColor,
                            ),
                          )
                    : const SizedBox.shrink()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 1.sw,
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.order.items.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (itemIndex != i) {
                            setState(() {
                              itemIndex = i;
                              item = widget.order.items[i];
                              signData();
                            });
                          }
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: ImageBuilder(
                                imageUrl: widget.order.items[i].product!.image,
                                height: 40,
                                width: 60,
                              ),
                            ),
                            itemIndex == i
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.7),
                                  )
                                : const SizedBox.shrink(),
                            itemIndex == i
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 50,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  title: CustomText(
                    data: item.product!.name,
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
                                    color: ColorManager.kGrey.withOpacity(0.3),
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
                                          getSelectedColor: (color) =>
                                              setState(() {
                                            selectedColor = color;
                                            int index = item.statistics
                                                .indexWhere((element) =>
                                                    element.color ==
                                                        selectedColor &&
                                                    element.size ==
                                                        selectedSize);
                                            if (index > -1) {
                                              statistics =
                                                  item.statistics[index];
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
                                    : EdgeInsets.only(
                                        top: AppPadding.p5.h,
                                      ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      color:
                                          ColorManager.kGrey.withOpacity(0.3),
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
                                            getSelectedSize: (size) =>
                                                setState(() {
                                              selectedSize = size;
                                              int index = item.statistics
                                                  .indexWhere((element) =>
                                                      element.color ==
                                                          selectedColor &&
                                                      element.size ==
                                                          selectedSize);
                                              if (index > -1) {
                                                statistics =
                                                    item.statistics[index];
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
                        Divider(
                          color: ColorManager.kGrey.withOpacity(0.3),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                data: AppStrings.quantity.tr(),
                              ),
                            ),
                            CustomText(
                              data: quantity,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
              vertical: 15.h,
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            child: Row(
              children: List.generate(
                orderSummaryList.length,
                (index) => index == 2
                    ? OrderStatusSummaryItem(
                        orderSummary: orderSummaryList[index],
                        markIt: widget.order.status == AppStrings.delivered,
                        showSeperator: false,
                      )
                    : Expanded(
                        child: OrderStatusSummaryItem(
                          orderSummary: orderSummaryList[index],
                          markIt: widget.order.status != AppStrings.canceled &&
                              widget.order.status != AppStrings.pending &&
                              widget.order.status != AppStrings.confirmed &&
                              (index == 0
                                  ? true
                                  : widget.order.status !=
                                      AppStrings.underPrepare),
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
