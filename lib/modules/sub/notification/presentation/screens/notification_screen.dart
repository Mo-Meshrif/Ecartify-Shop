import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/utils/assets_manager.dart';
import '/../modules/sub/notification/domain/entities/notification.dart' as not;
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/notification_bloc.dart';
import '../widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool alertOpen = false;
  late NotificationBloc notificationBloc = context.read<NotificationBloc>();
  @override
  void initState() {
    getPageData();
    super.initState();
  }

  void getPageData() => notificationBloc.add(GetNotificationsEvent());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.nots.tr(),
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.readNotificationStatus == Status.loaded) {
              int index = state.notificationList.indexWhere(
                  (element) => element.id == state.readNotificationId);
              if (index > -1) {
                var notification = state.notificationList[index].copyWith(
                  status: '0',
                );
                state.notificationList.removeAt(index);
                state.notificationList.insert(index, notification);
                notificationBloc.add(GetUnReadNotificationEvent());
              }
            } else if (state.deleteNotificationStatus == Status.loading) {
              alertOpen = true;
              HelperFunctions.showPopUpLoading(context);
            } else if (state.deleteNotificationStatus == Status.loaded) {
              if (alertOpen) {
                alertOpen = false;
                NavigationHelper.pop(context);
                state.notificationList.removeWhere(
                  (element) => element.id == state.deleteNotificationId,
                );
                notificationBloc.add(GetUnReadNotificationEvent());
              }
            } else if (state.deleteNotificationStatus == Status.error) {
              if (alertOpen) {
                alertOpen = false;
                NavigationHelper.pop(context);
                HelperFunctions.showSnackBar(
                  context,
                  AppStrings.operationFailed.tr(),
                );
              }
            }
          },
          builder: (context, state) => state.notificationList.isEmpty
              ? Center(
                  child: state.notificationStatus == Status.loading ||
                          state.notificationStatus == Status.sleep
                      ? Lottie.asset(
                          JsonAssets.loading,
                          height: AppSize.s200,
                          width: AppSize.s200,
                        )
                      : Lottie.asset(JsonAssets.empty),
                )
              : ListView.separated(
                  itemCount: state.notificationList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p20.w,
                    vertical: AppPadding.p10.h,
                  ),
                  itemBuilder: (context, index) {
                    not.Notification notification =
                        state.notificationList[index];
                    return notification.status == '1'
                        ? ClipRect(
                            child: Banner(
                              message: AppStrings.unread.tr(),
                              location: BannerLocation.topStart,
                              child: NotificationWidget(
                                  notification: notification),
                            ),
                          )
                        : NotificationWidget(notification: notification);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: AppSize.s10.h,
                  ),
                ),
        ),
      );
}
