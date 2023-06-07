import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/custom_or_divider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p20.w,
          vertical: AppPadding.p10.h,
        ),
        child: Column(
          children: [
            CustomText(
              data: AppStrings.signIn.tr(),
              fontSize: 30.sp,
            ),
            SizedBox(height: AppSize.s50.h),
            TextFormField(
              decoration:  InputDecoration(
                hintText: AppStrings.email.tr(),
              ),
            ),
            SizedBox(height: AppSize.s20.h),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppStrings.password.tr(),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s20),
            CustomElevatedButton(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.p15.h,
              ),
              child: CustomText(
                data: AppStrings.signIn.tr(),
              ),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppPadding.p20),
              child: TextButton(
                onPressed: () {},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    ImageAssets.google,
                    width: AppSize.s25,
                    height: AppSize.s25,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.apple),
                ),
              ],
            ),
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
    );
  }
}
