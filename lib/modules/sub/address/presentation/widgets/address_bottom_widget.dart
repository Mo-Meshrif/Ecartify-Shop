import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/no_padding_check_box.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/address.dart';

class AddressBottomWidget extends StatefulWidget {
  final Address? address;

  const AddressBottomWidget({Key? key, this.address}) : super(key: key);

  @override
  State<AddressBottomWidget> createState() => _AddressBottomWidgetState();
}

class _AddressBottomWidgetState extends State<AddressBottomWidget> {
  late bool isEdit = widget.address != null;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: ColorManager.kGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s25.r),
          topRight: Radius.circular(AppSize.s25.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.p20.h,
          horizontal: AppPadding.p15.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomText(
                data: AppStrings.addressDetails.tr(),
                fontWeight: FontWeight.bold,
                fontSize: AppSize.s25.sp,
              ),
            ),
            Divider(
              height: AppSize.s25.h,
            ),
            SizedBox(height: AppSize.s10.h),
            CustomText(
              data: AppStrings.nameAddress.tr(),
              fontWeight: FontWeight.bold,
              fontSize: AppSize.s20.sp,
            ),
            SizedBox(height: AppSize.s10.h),
            TextFormField(),
            SizedBox(height: AppSize.s10.h),
            CustomText(
              data: AppStrings.addressDetails.tr(),
              fontWeight: FontWeight.bold,
              fontSize: AppSize.s20.sp,
            ),
            SizedBox(height: AppSize.s10.h),
            TextFormField(),
            SizedBox(height: 15.h),
            Row(
              children: [
                NoPaddingCheckbox(
                  isMarked: false,
                  onChange: (newValue) {},
                  size: AppSize.s30,
                ),
                SizedBox(width: AppSize.s10.w),
                Expanded(
                  child: CustomText(
                    data: AppStrings.makeDefualt.tr(),
                  ),
                )
              ],
            ),
            SizedBox(height: AppSize.s20.h),
            CustomElevatedButton(
              onPressed: () {},
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.p20.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSize.s10.r,
                ),
              ),
              child: CustomText(
                data: isEdit
                    ? AppStrings.editAddress.tr()
                    : AppStrings.addNewAddress.tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
