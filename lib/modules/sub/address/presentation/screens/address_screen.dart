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
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/address.dart';
import '../controller/address_bloc.dart';
import '../widgets/address_item.dart';
import 'add_edit_address_screen.dart';

class AddressScreen extends StatefulWidget {
  final bool fromCheckout;
  const AddressScreen({Key? key, this.fromCheckout = false}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _hasOperation = false;
  @override
  void initState() {
    if (!widget.fromCheckout) {
      sl<AddressBloc>().add(GetAddressListEvent());
    }
    super.initState();
  }

  Widget? _trailingButton(Address address) => widget.fromCheckout
      ? IconButton(
          onPressed: () =>
              sl<AddressBloc>().add(SelectAddressEvent(address: address)),
          splashRadius: AppSize.s30.r,
          icon: Icon(
            address.selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off_outlined,
          ),
        )
      : null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.deliveryAddresses.tr(),
          ),
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (!widget.fromCheckout) {
              if (state.addAddressStatus == Status.loading ||
                  state.editAddressStatus == Status.loading) {
                if (!_hasOperation) {
                  _hasOperation = true;
                  HelperFunctions.showPopUpLoading(context);
                }
              } else if (state.addAddressStatus == Status.loaded ||
                  state.editAddressStatus == Status.loaded) {
                if (_hasOperation) {
                  NavigationHelper.pop(context);
                  _hasOperation = false;
                  NavigationHelper.pop(context);
                }
              } else if (state.addAddressStatus == Status.error ||
                  state.editAddressStatus == Status.error) {
                if (_hasOperation) {
                  _hasOperation = false;
                  NavigationHelper.pop(context);
                }
              }
            }
          },
          builder: (context, state) => state.addressListStatus == Status.loading
              ? Center(child: Lottie.asset(JsonAssets.loading))
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p15.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: state.addressList.isEmpty
                            ? Center(child: Lottie.asset(JsonAssets.empty))
                            : ListView.separated(
                                itemCount: state.addressList.length,
                                itemBuilder: (context, index) {
                                  Address address = state.addressList[index];
                                  bool selected =
                                      state.userAddress?.id == address.id;
                                  return address.isDefault &&
                                          !widget.fromCheckout
                                      ? ClipRect(
                                          child: Banner(
                                            message:
                                                AppStrings.defaultText.tr(),
                                            location: BannerLocation.topStart,
                                            child: AddressItem(
                                              address: address,
                                            ),
                                          ),
                                        )
                                      : AddressItem(
                                          address: address,
                                          trailingButton: _trailingButton(
                                            address.copyWith(
                                              selected: selected,
                                            ),
                                          ),
                                        );
                                },
                                separatorBuilder: (_, __) => SizedBox(
                                  height: AppSize.s10.h,
                                ),
                              ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                        child: CustomElevatedButton(
                          onPressed: () => NavigationHelper.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditAddressScreen(
                                forceDefault: widget.fromCheckout,
                              ),
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSize.s10.r),
                          ),
                          child: CustomText(
                            data: AppStrings.addNewAddress.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}
