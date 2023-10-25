import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badge;

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/notification/presentation/controller/notification_bloc.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    String name = HelperFunctions.lastUserName();
    String welcome = HelperFunctions.welcome();
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p5.h),
      child: Row(
        children: [
          Expanded(
            child: name.isEmpty
                ? CustomText(
                    data: welcome.tr(),
                    fontSize: AppSize.s25.sp,
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: AppSize.s30.r,
                      backgroundColor: primaryColor,
                      child: CustomText(
                        data: name[0].toUpperCase(),
                        color: Theme.of(context).canvasColor,
                        fontSize: AppSize.s25.sp,
                      ),
                    ),
                    title: CustomText(
                      data: welcome.tr(),
                      fontSize: AppSize.s20.sp,
                    ),
                    subtitle: CustomText(
                      data: name,
                      fontSize: AppSize.s25.sp,
                    ),
                  ),
          ),
          BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state.unReadNumStatus == Status.loaded ||
                  state.unReadNumStatus == Status.error) {
                sl<AwesomeNotifications>().setGlobalBadgeCounter(
                  int.parse(state.unReadNum),
                );
              }
            },
            builder: (context, state) => InkWell(
              onTap: () => NavigationHelper.pushNamed(
                context,
                Routes.notificationRoute,
              ),
              borderRadius: BorderRadius.circular(AppSize.s10.r),
              child: badge.Badge(
                position: badge.BadgePosition.topEnd(top: -5, end: 5),
                showBadge: state.unReadNum != '0',
                badgeContent: CustomText(
                  data: state.unReadNum,
                  fontSize: 17.sp,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset(
                    IconAssets.bell,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
