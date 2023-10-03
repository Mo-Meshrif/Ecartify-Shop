import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/theme_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../control/presentation/controller/app_config_bloc.dart';

class BillingFormData extends StatefulWidget {
  final void Function(
    String firstName,
    String lastName,
    String email,
    String mobile,
  ) onFinish;
  const BillingFormData({
    Key? key,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<BillingFormData> createState() => _BillingFormDataState();
}

class _BillingFormDataState extends State<BillingFormData> {
  GlobalKey<FormState> billingKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      emailController = TextEditingController(),
      mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (context, state) => Theme(
          data: state.themeMode == ThemeMode.light
              ? ThemeManager.darkTheme()
              : ThemeManager.lightTheme(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p15.w,
              vertical: AppPadding.p10.h,
            ),
            child: Form(
              key: billingKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: AppStrings.billingData.tr(),
                    color: Theme.of(context).canvasColor,
                    fontSize: AppSize.s30.sp,
                  ),
                  SizedBox(height: AppSize.s10.h),
                  CustomText(
                    data: AppStrings.fillMissingData.tr(),
                    color: ColorManager.kGrey,
                  ),
                  SizedBox(height: AppSize.s20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: AppStrings.firstName.tr(),
                          ),
                          validator: (value) => value!.isEmpty
                              ? AppStrings.enterFirstName.tr()
                              : null,
                        ),
                      ),
                      SizedBox(width: AppSize.s10.w),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: AppStrings.lastName.tr(),
                          ),
                          validator: (value) => value!.isEmpty
                              ? AppStrings.enterLastName.tr()
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s20.h),
                  TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: AppStrings.email.tr(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? AppStrings.enterEmail.tr()
                        : !HelperFunctions.isEmailValid(value)
                            ? AppStrings.notVaildEmail.tr()
                            : null,
                  ),
                  SizedBox(height: AppSize.s20.h),
                  TextFormField(
                    controller: mobileController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: AppStrings.mobile.tr(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? AppStrings.enterMobile.tr() : null,
                  ),
                  SizedBox(height: AppSize.s20.h),
                  CustomElevatedButton(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p20.h,
                    ),
                    child: CustomText(
                      data: AppStrings.continueToPayment.tr(),
                    ),
                    onPressed: () {
                      if (billingKey.currentState!.validate()) {
                        billingKey.currentState!.save();
                        NavigationHelper.pop(context);
                        widget.onFinish(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          mobileController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
