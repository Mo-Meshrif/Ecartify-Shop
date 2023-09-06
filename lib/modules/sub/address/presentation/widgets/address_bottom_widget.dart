import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/no_padding_check_box.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/address.dart';

class AddressBottomWidget extends StatefulWidget {
  final TextEditingController addressName, addressDetails;
  final Address? address;
  final bool forceDefault;
  final Function(
    bool isDefault,
  ) onClickButton;

  const AddressBottomWidget({
    Key? key,
    required this.addressName,
    required this.addressDetails,
    this.address,
    required this.forceDefault,
    required this.onClickButton,
  }) : super(key: key);

  @override
  State<AddressBottomWidget> createState() => _AddressBottomWidgetState();
}

class _AddressBottomWidgetState extends State<AddressBottomWidget> {
  late bool isEdit, isDefault;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      isEdit = widget.address != null;
      isDefault = isEdit ? widget.address!.isDefault : false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
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
          child: Form(
            key: formKey,
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
                TextFormField(
                  controller: widget.addressName,
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value!.isEmpty ? AppStrings.enterAddressName.tr() : null,
                ),
                SizedBox(height: AppSize.s10.h),
                CustomText(
                  data: AppStrings.addressDetails.tr(),
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s20.sp,
                ),
                SizedBox(height: AppSize.s10.h),
                TextFormField(
                  controller: widget.addressDetails,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 2,
                  validator: (value) => value!.isEmpty
                      ? AppStrings.enterAddressDetails.tr()
                      : null,
                ),
                Visibility(
                  visible: isEdit
                      ? !widget.address!.isDefault
                      : !widget.forceDefault,
                  child: Padding(
                    padding: EdgeInsets.only(top: AppPadding.p15.h),
                    child: Row(
                      children: [
                        NoPaddingCheckbox(
                          isMarked: isDefault,
                          onChange: (newValue) => setState(
                            () => isDefault = newValue,
                          ),
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
                  ),
                ),
                SizedBox(height: AppSize.s20.h),
                CustomElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      widget.onClickButton(isDefault);
                    }
                  },
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
        ),
      );
}
