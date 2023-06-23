import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import 'notification_details_widget.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListTile(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: ColorManager.kGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.s15.r),
            topRight: Radius.circular(AppSize.s15.r),
          ),
        ),
        constraints: BoxConstraints(
          minHeight: 1.sh * 0.3,
          maxHeight: 1.sh * 0.85,
        ),
        builder: (context) => const NotificationDetailsWidget(),
      ),
      tileColor: ColorManager.kGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s15.r),
      ),
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        radius: AppSize.s30.r,
        child: Icon(
          Icons.notifications,
          color: theme.canvasColor,
        ),
      ),
      title: const CustomText(
        data: 'Notification title',
        maxLines: 1,
      ),
      subtitle: const CustomText(
        data: 'Notification desc',
        maxLines: 2,
      ),
    );
  }
}
