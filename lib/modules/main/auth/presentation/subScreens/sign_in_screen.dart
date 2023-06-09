import 'package:easy_localization/easy_localization.dart';
import 'package:ecartify/app/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/usecases/login_use_case.dart';
import '../controller/auth_bloc.dart';
import '../widgets/custom_or_divider.dart';
import '../widgets/hor_social_buttons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> signInKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
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
            key: signInKey,
            child: Column(
              children: [
                CustomText(
                  data: AppStrings.signIn.tr(),
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
                    data: AppStrings.signIn.tr(),
                  ),
                  onPressed: () {
                    if (signInKey.currentState!.validate()) {
                      signInKey.currentState!.save();
                      context.read<AuthBloc>().add(
                            LoginEvent(
                              loginInputs: LoginInputs(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            ),
                          );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p20),
                  child: TextButton(
                    onPressed: () => NavigationHelper.pushNamed(
                      context,
                      Routes.forgetPasseordRoute,
                    ),
                    child: CustomText(
                      data: AppStrings.forgetPass.tr(),
                    ),
                  ),
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
