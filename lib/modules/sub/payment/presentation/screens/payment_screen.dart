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
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/payment_method.dart';
import '../controller/payment_bloc.dart';

class PaymentScreen extends StatefulWidget {
  final double totalPrice;
  const PaymentScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? selecedPayment;
  late List<PaymentMethod> paymentList = [
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
    const PaymentMethod(
      title: AppStrings.googlePay,
      pic: IconAssets.google,
      paymentType: PaymentType.googlePay,
    ),
    const PaymentMethod(
      title: AppStrings.applePay,
      pic: IconAssets.apple,
      paymentType: PaymentType.applePay,
    ),
  ];

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
              //TODO hanlde order event
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
                    CustomElevatedButton(
                      onPressed: selecedPayment == null
                          ? null
                          : () => sl<PaymentBloc>().add(
                                PaymentToggleEvent(
                                  paymentType: selecedPayment!.paymentType,
                                  totalPrice: widget.totalPrice,
                                  currency: 'USD',
                                ),
                              ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p20.h,
                      ),
                      child: CustomText(
                        data: AppStrings.confirmPayment.tr(),
                      ),
                    )
                  ],
                ),
        ),
      );
}
