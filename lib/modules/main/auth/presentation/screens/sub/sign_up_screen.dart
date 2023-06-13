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
import '../../../domain/usecases/signup_use_case.dart';
import '../../controller/auth_bloc.dart';
import '../../widgets/custom_or_divider.dart';
import '../../widgets/hor_social_buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
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
            key: signUpKey,
            child: Column(
              children: [
                CustomText(
                  data: AppStrings.signUp.tr(),
                  fontSize: 30.sp,
                ),
                SizedBox(height: AppSize.s50.h),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: AppStrings.username.tr(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? AppStrings.enterName.tr() : null,
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
                  obscureText: obscureText,
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: AppStrings.password.tr(),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => obscureText = !obscureText),
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) => value!.isEmpty
                      ? AppStrings.enterPassword.tr()
                      : value.length < 8
                          ? AppStrings.notVaildPassword.tr()
                          : null,
                ),
                const SizedBox(height: AppSize.s20),
                CustomElevatedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.p15.h,
                  ),
                  child: CustomText(
                    data: AppStrings.signUp.tr(),
                  ),
                  onPressed: () {
                    if (signUpKey.currentState!.validate()) {
                      signUpKey.currentState!.save();
                      context.read<AuthBloc>().add(
                            SignUpEvent(
                              signUpInputs: SignUpInputs(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              ),
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
                      data: AppStrings.haveAccount.tr(),
                      color: ColorManager.kGrey,
                    ),
                    TextButton(
                      onPressed: () => NavigationHelper.pushNamed(
                        context,
                        Routes.signInRoute,
                      ),
                      child: CustomText(
                        data: AppStrings.signIn.tr(),
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
