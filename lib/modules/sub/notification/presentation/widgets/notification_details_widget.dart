import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/../modules/sub/notification/domain/entities/notification.dart' as not;
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/values_manager.dart';

class NotificationDetailsWidget extends StatelessWidget {
  final not.Notification notification;
  const NotificationDetailsWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p15.w,
        vertical: AppPadding.p10.h,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.p15.h),
            child: CustomText(
              data: notification.title,
            ),
          ),
          Divider(color: theme.primaryColor),
          SizedBox(height: AppSize.s15.h),
          Expanded(
            child: SingleChildScrollView(
              child: CustomText(
                data: notification.content,
              ),
            ),
          )
        ],
      ),
    );
  }
}
