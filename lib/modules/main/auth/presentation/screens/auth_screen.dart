import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: AppPadding.p10.h,
            bottom: AppPadding.p30.h,
            right: AppPadding.p20.w,
            left: AppPadding.p20.w,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageAssets.generalWel,
              ),
              alignment: AlignmentDirectional.topCenter,
            ),
          ),
          child: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.facebook,
                    ),
                    title: CustomText(
                      data: AppStrings.withFacebook.tr(),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      ImageAssets.google,
                      width: AppSize.s25,
                      height: AppSize.s25,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: CustomText(
                      data: AppStrings.withGoogle.tr(),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.apple,
                    ),
                    title: CustomText(
                      data: AppStrings.withApple.tr(),
                    ),
                  ),
                  CustomOrDivider(
                    text: AppStrings.or.tr(),
                  ),
                  const SizedBox(height: AppSize.s10),
                  CustomElevatedButton(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p15.h,
                    ),
                    child: CustomText(
                      data: AppStrings.signIn.tr(),
                    ),
                    onPressed: () => NavigationHelper.pushNamed(
                      context,
                      Routes.signInRoute,
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
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
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
