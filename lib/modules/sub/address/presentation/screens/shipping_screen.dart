import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/shipping.dart';
import '../controller/address_bloc.dart';
import '../widgets/shipping_item.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  @override
  void initState() {
    getPageContent();
    super.initState();
  }

  getPageContent() => sl<AddressBloc>().add(GetShippingListEvent());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.shippingType.tr(),
          ),
        ),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) =>
              state.shippingListStatus == Status.loaded ||
                      state.shippingListStatus == Status.error
                  ? state.shippingList.isEmpty
                      ? Center(child: Lottie.asset(JsonAssets.empty))
                      : RefreshIndicator(
                          color: Theme.of(context).canvasColor,
                          backgroundColor: Theme.of(context).primaryColor,
                          onRefresh: () {
                            getPageContent();
                            return Future.value();
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p15.w,
                              vertical: AppPadding.p10.h,
                            ),
                            itemCount: state.shippingList.length,
                            itemBuilder: (context, index) {
                              Shipping tempShipping = state.shippingList[index];
                              Shipping shipping = tempShipping.copyWith(
                                state.userShipping?.id == tempShipping.id,
                              );
                              return ShippingItem(shipping: shipping);
                            },
                            separatorBuilder: (_, __) => SizedBox(
                              height: AppSize.s10.h,
                            ),
                          ),
                        )
                  : Center(
                      child: Lottie.asset(
                        JsonAssets.loading,
                        height: AppSize.s200,
                        width: AppSize.s200,
                      ),
                    ),
        ),
      );
}
