import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/notification_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: 'Notifications',
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: ListView.separated(
          itemCount: 10,
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p20.w,
            vertical: AppPadding.p10.h,
          ),
          itemBuilder: (context, index) => const NotificationWidget(),
          separatorBuilder: (context, index) => SizedBox(height: AppSize.s10.h),
        ),
      );
}
