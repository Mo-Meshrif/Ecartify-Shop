import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/order.dart';

class SuccessOrderScreen extends StatelessWidget {
  final OrderEntity order;
  const SuccessOrderScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 30,
                  child: Icon(
                    Icons.check,
                    size: 50.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomText(
                  data: AppStrings.orderSuccessTitle.tr(),
                  fontSize: 20.sp,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  data: AppStrings.orderSuccessDesc.tr(),
                  fontSize: 17.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 30.h),
                CustomElevatedButton(
                  width: 1.sw / 2,
                  child: CustomText(
                    data: AppStrings.viewOrder.tr(),
                  ),
                  onPressed: () {
                    //TODO order details
                  },
                ),
                CustomElevatedButton(
                  width: 1.sw / 2,
                  child: CustomText(
                    data: AppStrings.backHome.tr(),
                  ),
                  onPressed: () => NavigationHelper.pushReplacementNamed(
                    context,
                    Routes.controlRoute,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
