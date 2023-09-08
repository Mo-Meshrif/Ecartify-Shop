import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
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
  @override
  void initState() {
    sl<AddressBloc>().add(GetAddressListEvent());
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
          builder: (context, addressState) => addressState.addressListStatus ==
                  Status.loading
              ? Center(child: Lottie.asset(JsonAssets.loading))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      SizedBox(height: AppSize.s15.h),
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
                      SizedBox(height: AppSize.s15.h),
                      const Divider(),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) => Theme(
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
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
        ),
      );
}
