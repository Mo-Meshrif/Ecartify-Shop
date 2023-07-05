import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/models/profile_item.dart';
import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../control/presentation/controller/app_config_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isDark = Theme.of(context).brightness == Brightness.dark;
  List<ProfileItem> profileItems = [
    ProfileItem(
      icon: IconAssets.orders,
      title: AppStrings.orders,
      onTap: () {},
    ),
    ProfileItem(
      icon: IconAssets.deliceryAddress,
      title: AppStrings.deliceryAddress,
      onTap: () {},
    ),
    ProfileItem(
      icon: IconAssets.payment,
      title: AppStrings.payment,
      onTap: () {},
    ),
    ProfileItem(
      icon: IconAssets.privacy,
      title: AppStrings.privacy,
      onTap: () {},
    ),
    ProfileItem(
      icon: IconAssets.help,
      title: AppStrings.help,
      onTap: () {},
    ),
    ProfileItem(
      icon: IconAssets.about,
      title: AppStrings.about,
      onTap: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.profile.tr(),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => HelperFunctions.toggleLanguage(context),
              splashRadius: AppSize.s30.r,
              icon: Image.asset(
                ImageAssets.translation,
                color: Theme.of(context).primaryColor,
                height: AppSize.s35.h,
                width: AppSize.s35.w,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() => isDark = !isDark);
                context.read<AppConfigBloc>().add(
                      ToggleThemeEvent(
                        isDark,
                      ),
                    );
              },
              splashRadius: AppSize.s30.r,
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: AppSize.s30.r,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CustomText(
                      data: 'M',
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                  title: CustomText(
                    data: 'Mohamed Meshrif',
                    fontSize: AppSize.s20.sp,
                  ),
                  subtitle: CustomText(
                    data: 'm.meshrif77@gmail.com',
                    fontSize: AppSize.s15.sp,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    splashRadius: AppSize.s30.r,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p10.w,
                    vertical: AppPadding.p15.h,
                  ),
                  child: Column(
                    children: List.generate(
                      profileItems.length,
                      (index) => ListTile(
                        horizontalTitleGap: AppSize.s5.w,
                        onTap: profileItems[index].onTap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s5.r),
                        ),
                        leading: SvgPicture.asset(
                          profileItems[index].icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: CustomText(data: profileItems[index].title.tr()),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p10.w,
                vertical: AppPadding.p15.h,
              ),
              child: CustomElevatedButton(
                onPressed: () {},
                padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                child: Row(
                  children: [
                    SizedBox(width: AppSize.s20.w),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                        HelperFunctions.rotateVal(
                          context,
                          rotate: true,
                        ),
                      ),
                      child: SvgPicture.asset(
                        IconAssets.logout,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: CustomText(
                          data: AppStrings.logout.tr(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
