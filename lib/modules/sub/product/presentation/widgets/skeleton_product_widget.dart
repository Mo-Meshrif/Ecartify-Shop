import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/skeleton.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class SkeletonProductWidget extends StatelessWidget {
  const SkeletonProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSize.s15.r,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(
              height: AppSize.s205.h,
              borderRadius: BorderRadius.circular(AppSize.s15.r),
            ),
            SizedBox(height: AppSize.s5.h),
            Skeleton(
              height: AppSize.s15.h,
              borderRadius: BorderRadius.circular(AppSize.s5.r),
            ),
            SizedBox(height: AppSize.s5.h),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Skeleton(
                      height: AppSize.s15.h,
                      borderRadius: BorderRadius.circular(AppSize.s5.r),
                    ),
                  ),
                  VerticalDivider(
                    color: ColorManager.kGrey.withOpacity(0.3),
                  ),
                  Expanded(
                    child: Skeleton(
                      height: AppSize.s15.h,
                      borderRadius: BorderRadius.circular(AppSize.s5.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.s5.h),
            Skeleton(
              height: AppSize.s15.h,
              borderRadius: BorderRadius.circular(AppSize.s5.r),
            ),
            SizedBox(height: AppSize.s5.h),
          ],
        ),
      ),
    );
  }
}
