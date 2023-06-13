import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/helper_functions.dart';
import '../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../app/utils/color_manager.dart';
import '../../../../../../app/utils/routes_manager.dart';
import '../../../../../../app/utils/strings_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import '../../controller/auth_bloc.dart';
import '../../widgets/custom_or_divider.dart';
import '../../widgets/hor_social_buttons.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p20.w,
            vertical: AppPadding.p10.h,
          ),
          child: Form(
            key: forgetPasswordKey,
            child: Column(
              children: [
                CustomText(
                  data: AppStrings.forgetPass.tr(),
                  fontSize: 30.sp,
                ),
                SizedBox(height: AppSize.s50.h),
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
                const SizedBox(height: AppSize.s20),
                CustomElevatedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.p15.h,
                  ),
                  child: CustomText(
                    data: AppStrings.continueProcess.tr(),
                  ),
                  onPressed: () {
                    if (forgetPasswordKey.currentState!.validate()) {
                      forgetPasswordKey.currentState!.save();
                      context.read<AuthBloc>().add(
                            ForgetPasswordEvent(
                              email: emailController.text,
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: AppSize.s20),
                CustomOrDivider(
                  text: AppStrings.orWith.tr(),
                ),
                const SizedBox(height: AppSize.s20),
                const HorizontalSocialButtons(),
                const SizedBox(height: AppSize.s30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      data: AppStrings.noAccount.tr(),
                      color: ColorManager.kGrey,
                    ),
                    TextButton(
                      onPressed: () => NavigationHelper.pushNamed(
                        context,
                        Routes.signUpRoute,
                      ),
                      child: CustomText(
                        data: AppStrings.signUp.tr(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s20),
              ],
            ),
          ),
        ),
      );
}
