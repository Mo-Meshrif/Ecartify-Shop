import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/models/profile_item.dart';
import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../control/presentation/controller/app_config_bloc.dart';
import '../../../../sub/payment/presentation/screens/currency_screen.dart';
import '../controller/profile_bloc.dart';
import '../widgets/about_widget.dart';
import '../widgets/edit_profile_widget.dart';
import '../widgets/privacy_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.isGuest = false}) : super(key: key);
  final bool isGuest;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  String name = '';
  late bool isDark = Theme.of(context).brightness == Brightness.dark;
  List<ProfileItem> profileItems = [
    ProfileItem(
      icon: IconAssets.orders,
      title: AppStrings.orders,
    ),
    ProfileItem(
      icon: IconAssets.deliveryAddress,
      title: AppStrings.deliveryAddresses,
    ),
    ProfileItem(
      icon: IconAssets.wallet,
      title: AppStrings.wallet,
    ),
    ProfileItem(
      icon: IconAssets.currency,
      title: AppStrings.currencies,
    ),
    ProfileItem(
      icon: IconAssets.privacy,
      title: AppStrings.privacy,
    ),
    ProfileItem(
      icon: IconAssets.help,
      title: AppStrings.help,
    ),
    ProfileItem(
      icon: IconAssets.about,
      title: AppStrings.about,
    ),
  ];

  @override
  void initState() {
    if (!widget.isGuest) {
      getPagetContent();
    }
    super.initState();
  }

  getPagetContent() => sl<ProfileBloc>().add(GetUserData());

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
        body: widget.isGuest
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const AboutWidget(),
                    SizedBox(height: AppSize.s20.h),
                    CustomElevatedButton(
                      width: 1.sw * 0.75,
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p15.h,
                      ),
                      child: CustomText(
                        data: AppStrings.signInToExplore.tr(),
                      ),
                      onPressed: () {
                        sl<AppShared>().removeVal(
                          AppConstants.guestKey,
                        );
                        NavigationHelper.pushNamedAndRemoveUntil(
                          context,
                          Routes.controlRoute,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              )
            : BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state.userStatus == Status.loading) {
                    loading = true;
                  } else if (state.userStatus == Status.loaded ||
                      state.userStatus == Status.error) {
                    if (state.userStatus == Status.loaded) {
                      name = HelperFunctions.lastUserName();
                    }
                    if (loading) {
                      loading = false;
                    }
                  } else if (state.logoutStatus == Status.loading ||
                      state.deleteUserStatus == Status.loading) {
                    HelperFunctions.showPopUpLoading(context);
                  } else if (state.logoutStatus == Status.error ||
                      state.deleteUserStatus == Status.error) {
                    NavigationHelper.pop(context);
                  } else if (state.logoutStatus == Status.loaded ||
                      state.deleteUserStatus == Status.loaded) {
                    NavigationHelper.pop(context);
                    sl<AppShared>().removeVal(AppConstants.authPassKey);
                    sl<AppShared>().removeVal(AppConstants.userKey);
                    NavigationHelper.pushNamedAndRemoveUntil(
                      context,
                      Routes.controlRoute,
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) => loading || state.user == null
                    ? Center(
                        child: loading
                            ? Lottie.asset(
                                JsonAssets.loading,
                                height: AppSize.s200,
                                width: AppSize.s200,
                              )
                            : const Icon(Icons.error),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: AppSize.s30.r,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: CustomText(
                                        data: name[0].toUpperCase(),
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                    title: CustomText(
                                      data: name,
                                      fontSize: AppSize.s20.sp,
                                    ),
                                    subtitle: CustomText(
                                      data: state.user!.email,
                                      fontSize: AppSize.s15.sp,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () => NavigationHelper.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            appBar: AppBar(),
                                            body: EditProfileWidget(
                                              user: state.user!,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                          onTap: () {
                                            switch (index) {
                                              case 0:
                                                NavigationHelper.pushNamed(
                                                  context,
                                                  Routes.orderRoute,
                                                );
                                                break;
                                              case 1:
                                                NavigationHelper.pushNamed(
                                                  context,
                                                  Routes.addressRoute,
                                                );
                                                break;
                                              case 2:
                                                NavigationHelper.pushNamed(
                                                  context,
                                                  Routes.walletRoute,
                                                );
                                                break;
                                              case 3:
                                                NavigationHelper.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CurrencyScreen(),
                                                  ),
                                                );
                                                break;
                                              case 4:
                                                NavigationHelper.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Scaffold(
                                                      appBar: AppBar(
                                                        title: CustomText(
                                                          data: AppStrings
                                                              .privacy
                                                              .tr(),
                                                        ),
                                                      ),
                                                      body:
                                                          const PrivacyWidget(),
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case 5:
                                                NavigationHelper.pushNamed(
                                                  context,
                                                  Routes.helpRoute,
                                                );
                                                break;
                                              case 6:
                                                NavigationHelper.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Scaffold(
                                                      appBar: AppBar(
                                                        title: CustomText(
                                                          data: AppStrings.about
                                                              .tr(),
                                                        ),
                                                      ),
                                                      body: const AboutWidget(),
                                                    ),
                                                  ),
                                                );
                                                break;
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppSize.s5.r),
                                          ),
                                          leading: SvgPicture.asset(
                                            profileItems[index].icon,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: CustomText(
                                            data:
                                                profileItems[index].title.tr(),
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p10.w,
                              vertical: AppPadding.p15.h,
                            ),
                            child: CustomElevatedButton(
                              onPressed: () =>
                                  sl<ProfileBloc>().add(LogoutEvent()),
                              padding: EdgeInsets.symmetric(
                                vertical: AppPadding.p20.h,
                              ),
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
              ),
      );
}
