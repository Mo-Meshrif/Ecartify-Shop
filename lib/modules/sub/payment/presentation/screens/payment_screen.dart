import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/cart/domain/entities/cart_item.dart';
import '../../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../../address/domain/entities/address.dart';
import '../../../order/domain/entities/order.dart';
import '../../../order/presentation/controller/order_bloc.dart';
import '../../domain/entities/payment_method.dart';
import '../controller/payment_bloc.dart';

class PaymentScreen extends StatefulWidget {
  final double promoVal, shippingVal, itemsPrice, totalPrice;
  final String shippingType;
  final Address userAddress;
  final List<CartItem> items;
  const PaymentScreen({
    Key? key,
    required this.items,
    required this.promoVal,
    required this.shippingVal,
    required this.itemsPrice,
    required this.totalPrice,
    required this.userAddress,
    required this.shippingType,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? selecedPayment;
  late List<PaymentMethod> paymentList = [
    PaymentMethod(
      title: AppStrings.cash.tr(),
      pic: IconAssets.cash,
      paymentType: PaymentType.cashOnDelivery,
    ),
    PaymentMethod(
      title: AppStrings.wallet.tr(),
      pic: IconAssets.wallet,
      color: Theme.of(context).primaryColor,
      paymentType: PaymentType.wallet,
    ),
    const PaymentMethod(
      title: AppStrings.stripe,
      pic: IconAssets.stripe,
      paymentType: PaymentType.stripe,
    ),
    PaymentMethod(
      title: AppStrings.paymob,
      pic: IconAssets.paymob,
      color: Theme.of(context).primaryColor,
      paymentType: PaymentType.paymob,
    ),
    const PaymentMethod(
      title: AppStrings.paypal,
      pic: IconAssets.paypal,
      paymentType: PaymentType.paypal,
    ),
  ];

  addOrder({
    String transactionId = '',
    required String currency,
    required String paymentMethod,
  }) {
    sl<OrderBloc>().add(
      AddOrderEvent(
        order: OrderEntity(
          currency: currency,
          paymentMethod: paymentMethod,
          transactionId: transactionId,
          totalPrice: widget.totalPrice.toString(),
          dateAdded: DateTime.now(),
          items: widget.items,
          promoVal: widget.promoVal.toString(),
          shippingVal: widget.shippingVal.toString(),
          itemsPrice: widget.itemsPrice.toString(),
          shippingType: widget.shippingType.toString(),
          status: AppStrings.pending,
          userAddress: widget.userAddress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.payment.tr(),
          ),
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state.paymentStatus == Status.loaded) {
              addOrder(
                transactionId: state.transactionId,
                currency: state.currency.selectedBase,
                paymentMethod: selecedPayment!.title,
              );
            } else if (state.paymentStatus == Status.error) {
              if (state.msg.isNotEmpty) {
                HelperFunctions.showSnackBar(
                  context,
                  state.msg,
                );
              }
            }
          },
          builder: (context, state) => state.paymentStatus == Status.initial
              ? Center(
                  child: Lottie.asset(
                    JsonAssets.loading,
                    height: AppSize.s200,
                    width: AppSize.s200,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppPadding.p15.w,
                          AppPadding.p10.h,
                          AppPadding.p15.w,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              data: AppStrings.selectPayment.tr(),
                              color: ColorManager.kGrey,
                            ),
                            SizedBox(height: AppSize.s20.h),
                            Column(
                              children: List.generate(
                                paymentList.length,
                                (index) => Padding(
                                  padding:
                                      EdgeInsets.only(bottom: AppSize.s10.h),
                                  child: ListTile(
                                    onTap: () => setState(
                                      () => selecedPayment = paymentList[index],
                                    ),
                                    tileColor:
                                        ColorManager.kGrey.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.s10.r,
                                      ),
                                    ),
                                    leading: SvgPicture.asset(
                                      paymentList[index].pic,
                                      color: paymentList[index].color,
                                    ),
                                    title: CustomText(
                                      data: paymentList[index].title,
                                    ),
                                    trailing: Icon(
                                      selecedPayment == paymentList[index]
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppPadding.p10.h),
                    BlocConsumer<OrderBloc, OrderState>(
                      listener: (context, orderState) {
                        if (orderState.addOrderStatus == Status.loading) {
                          HelperFunctions.showPopUpLoading(context);
                        } else if (orderState.addOrderStatus == Status.error ||
                            orderState.addOrderStatus == Status.loaded) {
                          NavigationHelper.pop(context);
                          if (orderState.addOrderStatus == Status.loaded) {
                            NavigationHelper.pushNamedAndRemoveUntil(
                              context,
                              Routes.sucessOrderRoute,
                              (route) => false,
                              arguments: orderState.tempOrder,
                            );
                            sl<CartBloc>().add(ClearCartEvent());
                          }
                        }
                      },
                      builder: (context, _) => CustomElevatedButton(
                        onPressed: selecedPayment == null ||
                                state.paymentStatus == Status.loading
                            ? null
                            : () {
                                if (selecedPayment!.paymentType ==
                                    PaymentType.cashOnDelivery) {
                                  addOrder(
                                    currency: state.currency.selectedBase,
                                    paymentMethod: selecedPayment!.title,
                                  );
                                } else {
                                  sl<PaymentBloc>().add(
                                    PaymentToggleEvent(
                                      context: context,
                                      paymentType: selecedPayment!.paymentType,
                                      totalPrice: widget.totalPrice,
                                    ),
                                  );
                                }
                              },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: AppPadding.p20.h,
                        ),
                        child: CustomText(
                          data: AppStrings.confirmPayment.tr(),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      );
}
