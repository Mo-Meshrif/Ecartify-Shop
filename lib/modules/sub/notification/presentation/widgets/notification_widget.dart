import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/../modules/sub/notification/domain/entities/notification.dart' as not;
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../product/domain/usecases/get_product_details_use_case.dart';
import '../../../product/presentation/controller/product_bloc.dart';
import '../../domain/usecases/read_notification_use_case.dart';
import '../controller/notification_bloc.dart';
import 'notification_details_widget.dart';

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
      onTap: () {
        if (notification.status == '1') {
          context.read<NotificationBloc>().add(
                ReadNotificationEvent(
                  updateNotification: UpdateNotification(
                    notification: notification,
                  ),
                ),
              );
        }
        if (notification.pageType == 'product') {
          context.read<ProductBloc>().add(
                GetProductDetailsEvent(
                  productDetailsParmeters: ProductDetailsParmeters(
                    productId: notification.url,
                  ),
                ),
              );
          NavigationHelper.pushNamed(
            context,
            Routes.productDetailsRoute,
          );
        } else {
          showModalBottomSheet(
            context: context,
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
            builder: (context) => NotificationDetailsWidget(
              notification: notification,
            ),
          );
        }
      },
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
