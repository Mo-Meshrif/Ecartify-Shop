import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../../../../sub/address/domain/entities/address.dart';
import '../../../../sub/address/presentation/controller/address_bloc.dart';
import '../../../../sub/address/presentation/widgets/add_new_address_widget.dart';
import '../../../../sub/address/presentation/widgets/address_item.dart';
import '../controller/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _hasOperation = false;
  TextEditingController promoController = TextEditingController();
  double promoVal = 0.0, shippingVal = 0.0, itemsPrice = 0.0;
  @override
  void initState() {
    sl<AddressBloc>().add(GetAddressListEvent());
    promoController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.checkout.tr(),
          ),
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, addressState) {
            if (addressState.addAddressStatus == Status.loading) {
              if (!_hasOperation) {
                _hasOperation = true;
                HelperFunctions.showPopUpLoading(context);
              }
            } else if (addressState.addAddressStatus == Status.loaded) {
              if (_hasOperation) {
                NavigationHelper.pop(context);
                _hasOperation = false;
                NavigationHelper.pop(context);
              }
            } else if (addressState.addAddressStatus == Status.error) {
              if (_hasOperation) {
                _hasOperation = false;
                NavigationHelper.pop(context);
              }
            }
          },
          builder: (context, addressState) =>
              addressState.addressListStatus == Status.loading
                  ? Center(child: Lottie.asset(JsonAssets.loading))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p15.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                SizedBox(height: AppSize.s15.h),
                                _deliveryAddress(addressState, context),
                                SizedBox(height: AppSize.s15.h),
                                const Divider(),
                                _orderList(),
                                const Divider(),
                                SizedBox(height: AppSize.s15.h),
                                _shippingType(),
                                SizedBox(height: AppSize.s15.h),
                                const Divider(),
                                SizedBox(height: AppSize.s15.h),
                                _promoCode(),
                                SizedBox(height: AppSize.s15.h),
                                _priceSummary(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSize.s15.h),
                        _toPayment(addressState.userAddress),
                      ],
                    ),
        ),
      );

  CustomElevatedButton _toPayment(Address? address) => CustomElevatedButton(
        onPressed: () {
          if (address == null) {
            HelperFunctions.showSnackBar(
              context,
              AppStrings.addNewAddress.tr(),
            );
          } else if (shippingVal == 0.0) {
            HelperFunctions.showSnackBar(
              context,
              AppStrings.chooseShippingType.tr(),
            );
          } else {
            double totalPrice = itemsPrice + shippingVal - promoVal;
            debugPrint(totalPrice.toStringAsFixed(2));
            //TODO add to payment logic
          }
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.p20.h,
        ),
        child: CustomText(
          data: AppStrings.continueToPayment.tr(),
        ),
      );

  Column _deliveryAddress(AddressState addressState, BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            data: AppStrings.deliveryAddress.tr(),
            fontSize: AppSize.s20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: AppSize.s15.h),
          addressState.userAddress != null
              ? AddressItem(
                  address: addressState.userAddress!,
                  trailingButton: IconButton(
                    onPressed: () => NavigationHelper.pushNamed(
                      context,
                      Routes.addressRoute,
                      arguments: true,
                    ),
                    splashRadius: AppSize.s30.r,
                    icon: const Icon(Icons.edit),
                  ),
                )
              : const AddNewAddressWidget(),
        ],
      );

  BlocBuilder<CartBloc, CartState> _orderList() =>
      BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          itemsPrice = cartState.totalPrice;
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              listTileTheme: const ListTileThemeData(
                contentPadding: EdgeInsets.zero,
                dense: true,
                horizontalTitleGap: 0.0,
                minLeadingWidth: 0,
              ),
            ),
            child: ExpansionTile(
              textColor: Theme.of(context).primaryColor,
              iconColor: Theme.of(context).primaryColor,
              tilePadding: EdgeInsets.zero,
              title: CustomText(
                data: AppStrings.orderList.tr(),
                fontSize: AppSize.s20.sp,
                fontWeight: FontWeight.bold,
              ),
              children: List.generate(
                cartState.cartItems.length,
                (index) => CartItemWidget(
                  key: Key(cartState.cartItems[index].prodId),
                  disableGestures: true,
                  cartItem: cartState.cartItems[index],
                ),
              ),
            ),
          );
        },
      );

  Column _shippingType() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            data: AppStrings.shippingType.tr(),
            fontSize: AppSize.s20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: AppSize.s15.h),
          ListTile(
            tileColor: ColorManager.kGrey.withOpacity(0.3),
            leading: const Icon(Icons.delivery_dining),
            title: CustomText(
              data: AppStrings.chooseShippingType.tr(),
              fontSize: AppSize.s20.sp,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s10.r),
            ),
            onTap: () {
              //TODO shipping logic
            },
          )
        ],
      );

  Column _promoCode() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            data: AppStrings.promoCode.tr(),
            fontSize: AppSize.s20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: AppSize.s15.h),
          ListTile(
            tileColor: ColorManager.kGrey.withOpacity(0.3),
            title: TextFormField(
              controller: promoController,
              decoration: InputDecoration(
                hintText: AppStrings.enterPromoCode.tr(),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            trailing: TextButton(
              child: CustomText(
                data: AppStrings.apply.tr(),
                fontSize: AppSize.s20.sp,
                fontWeight: FontWeight.bold,
              ),
              onPressed: promoController.text.isEmpty
                  ? null
                  : () {
                      debugPrint(promoController.text);
                      //TODO promo logic
                    },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s10.r),
            ),
          )
        ],
      );

  Container _priceSummary() {
    double totalPrice = itemsPrice + shippingVal - promoVal;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.kGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  data: AppStrings.itemsPrice.tr(),
                  fontSize: AppSize.s20.sp,
                ),
              ),
              CustomText(
                data: itemsPrice.toStringAsFixed(2),
                fontSize: AppSize.s20.sp,
              ),
            ],
          ),
          SizedBox(height: AppSize.s10.h),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  data: AppStrings.shipping.tr(),
                  fontSize: AppSize.s20.sp,
                ),
              ),
              CustomText(
                data: shippingVal.toStringAsFixed(2),
                fontSize: AppSize.s20.sp,
              ),
            ],
          ),
          SizedBox(height: AppSize.s10.h),
          Visibility(
            visible: promoVal != 0.0,
            child: Padding(
              padding: EdgeInsets.only(bottom: AppPadding.p10.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      data: AppStrings.promo.tr(),
                      fontSize: AppSize.s20.sp,
                    ),
                  ),
                  CustomText(
                    data: promoVal.toStringAsFixed(2),
                    fontSize: AppSize.s20.sp,
                    color: ColorManager.kRed,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          SizedBox(height: AppSize.s10.h),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  data: AppStrings.totalPrice.tr(),
                  fontSize: AppSize.s20.sp,
                ),
              ),
              CustomText(
                data: totalPrice.toStringAsFixed(2),
                fontSize: AppSize.s20.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
