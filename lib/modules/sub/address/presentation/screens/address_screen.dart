import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_item.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.deliceryAddress.tr(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p15.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    Address address = Address(
                      id: index.toString(),
                      name: 'Home',
                      lat: '',
                      lon: '',
                      details: '10 tonammal aga',
                    );
                    return index == 0
                        ? ClipRect(
                            child: Banner(
                              message: AppStrings.defaultText.tr(),
                              location: BannerLocation.topStart,
                              child: AddressItem(
                                address: address,
                              ),
                            ),
                          )
                        : AddressItem(address: address);
                  },
                  separatorBuilder: (_, __) => SizedBox(height: AppSize.s10.h),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                child: CustomElevatedButton(
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10.r),
                  ),
                  child: CustomText(data: AppStrings.addNewAddress.tr()),
                ),
              ),
            ],
          ),
        ),
      );
}
