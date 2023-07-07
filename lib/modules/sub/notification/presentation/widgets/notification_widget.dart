import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/../modules/sub/notification/domain/entities/notification.dart' as not;
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/notification_bloc.dart';

class NotificationWidget extends StatelessWidget {
  final not.Notification notification;
  const NotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListTile(
      onTap: () => context.read<NotificationBloc>().add(
            HandleNotificationClick(
              context: context,
              notification: notification,
            ),
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
      trailing: IconButton(
        splashRadius: AppSize.s25.r,
        icon: const Icon(Icons.delete),
        onPressed: () => context.read<NotificationBloc>().add(
              DeleteNotificationEvent(
                id: notification.id,
              ),
            ),
      ),
      title: CustomText(
        data: notification.title,
        maxLines: 1,
      ),
      subtitle: CustomText(
        data: notification.content,
        maxLines: 2,
      ),
    );
  }
}
