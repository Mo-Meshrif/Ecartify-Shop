import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/values_manager.dart';

class NotificationDetailsWidget extends StatelessWidget {
  const NotificationDetailsWidget({Key? key}) : super(key: key);

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
              data: 'Notification title',
              color: theme.canvasColor,
            ),
          ),
          Divider(color: theme.canvasColor),
          SizedBox(height: AppSize.s15.h),
          Expanded(
            child: SingleChildScrollView(
              child: CustomText(
                data: 'Notification desc',
                color: theme.canvasColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
